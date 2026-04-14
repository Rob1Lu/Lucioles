import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/providers/locale_provider.dart';

/// Données de lieu retournées par le widget.
///
/// [latitude] et [longitude] servent à positionner le marqueur sur la carte.
/// [nom] est l'adresse lisible (géocodage inverse) que l'utilisateur peut
/// personnaliser librement.
class LieuData {
  const LieuData({
    required this.latitude,
    required this.longitude,
    this.nom,
  });

  final double latitude;
  final double longitude;

  /// Adresse en clair — issue du géocodage inverse ou saisie manuelle
  final String? nom;

  /// Affichage dans l'UI : adresse si disponible, coordonnées sinon
  String get affichage =>
      nom != null && nom!.isNotEmpty
          ? nom!
          : '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}

/// Widget permettant d'associer optionnellement un lieu à une entrée.
///
/// Flux GPS :
///   1. Récupère les coordonnées via [Geolocator]
///   2. Appelle le géocodage inverse natif (CoreLocation / Android Geocoder)
///      pour obtenir une adresse lisible — aucune clé API requise
///   3. Pré-remplit le champ de nom que l'utilisateur peut modifier
class ChampLieuWidget extends StatefulWidget {
  const ChampLieuWidget({
    super.key,
    required this.onLieuChanged,
    this.lieuInitial,
  });

  final void Function(LieuData? lieu) onLieuChanged;
  final LieuData? lieuInitial;

  @override
  State<ChampLieuWidget> createState() => _ChampLieuWidgetState();
}

class _ChampLieuWidgetState extends State<ChampLieuWidget> {
  LieuData? _lieu;
  bool _chargement = false;
  String? _erreur;
  final TextEditingController _nomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lieu = widget.lieuInitial;
    if (_lieu?.nom != null) {
      _nomController.text = _lieu!.nom!;
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    super.dispose();
  }

  // ─── GPS + géocodage inverse ──────────────────────────────────────────────

  Future<void> _utiliserGPS() async {
    // Obtenir l10n et locale avant les appels async pour garder des références stables
    final l10n = AppLocalizations.of(context);
    final localeCode = context.read<LocaleProvider>().locale.languageCode;

    setState(() {
      _chargement = true;
      _erreur = null;
    });

    try {
      // 1. Vérifie le service de localisation
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _erreur = l10n.lieuGeolocDesactive);
        return;
      }

      // 2. Demande ou vérifie la permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() => _erreur = l10n.lieuPermissionRefusee);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _erreur = l10n.lieuPermissionDefinitive);
        return;
      }

      // 3. Obtient les coordonnées GPS
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Géocodage inverse : coordonnées → adresse lisible dans la langue de l'app
      final adresse = await _geocoderInverse(position.latitude, position.longitude, localeCode);

      final lieu = LieuData(
        latitude: position.latitude,
        longitude: position.longitude,
        nom: adresse,
      );

      if (mounted) {
        setState(() {
          _lieu = lieu;
          // Pré-remplit le champ avec l'adresse obtenue pour que l'utilisateur
          // puisse la garder telle quelle ou la personnaliser
          _nomController.text = adresse ?? '';
        });
        widget.onLieuChanged(lieu);
      }
    } catch (e) {
      if (mounted) setState(() => _erreur = l10n.lieuErreur);
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  /// Convertit des coordonnées GPS en une adresse courte et lisible.
  ///
  /// [localeCode] : code langue ISO 639-1 (ex: 'fr', 'en', 'es').
  /// Retourne null si le géocodage échoue (pas de réseau, zone inconnue…).
  Future<String?> _geocoderInverse(double lat, double lon, String localeCode) async {
    try {
      // geocoding 3.x : la locale se fixe via setLocaleIdentifier (format ll_CC)
      await setLocaleIdentifier(localeCode);
      final placemarks = await placemarkFromCoordinates(lat, lon);

      if (placemarks.isEmpty) return null;
      final p = placemarks.first;

      // Construit une adresse courte en combinant les composants disponibles
      final parties = <String>[
        // Rue (ex : "Rue de la Paix", "Place Bellecour")
        if (p.street != null && p.street!.isNotEmpty) p.street!,
        // Quartier si pas de rue (ex : "Croix-Rousse")
        if ((p.street == null || p.street!.isEmpty) &&
            p.subLocality != null &&
            p.subLocality!.isNotEmpty)
          p.subLocality!,
        // Ville (ex : "Lyon", "Paris")
        if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
      ];

      if (parties.isEmpty) return null;
      return parties.join(', ');
    } catch (_) {
      // Géocodage échoué (pas de réseau, etc.) — on revient aux coordonnées
      return null;
    }
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _supprimerLieu() {
    setState(() {
      _lieu = null;
      _nomController.clear();
      _erreur = null;
    });
    widget.onLieuChanged(null);
  }

  void _onNomChange(String nom) {
    if (_lieu == null) return;
    final lieuMisAJour = LieuData(
      latitude: _lieu!.latitude,
      longitude: _lieu!.longitude,
      nom: nom.trim().isEmpty ? null : nom.trim(),
    );
    setState(() => _lieu = lieuMisAJour);
    widget.onLieuChanged(lieuMisAJour);
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // ── Cas 1 : un lieu est sélectionné ───────────────────────────────────
    if (_lieu != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicateur avec les coordonnées en sous-texte discret
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.place_outlined, size: 16, color: AppTheme.terracotta),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _lieu!.affichage,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.terracotta,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Coordonnées brutes en filigrane — toujours conservées
                    Text(
                      '${_lieu!.latitude.toStringAsFixed(5)}, ${_lieu!.longitude.toStringAsFixed(5)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.texteTertaire,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _supprimerLieu,
                child: const Icon(Icons.close, size: 16, color: AppTheme.texteTertaire),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Champ de nom personnalisable — pré-rempli par le géocodage
          TextField(
            controller: _nomController,
            onChanged: _onNomChange,
            style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textePrincipal),
            decoration: InputDecoration(
              hintText: l10n.lieuPersonnaliserNom,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.texteTertaire,
                fontStyle: FontStyle.italic,
              ),
              prefixIcon: const Icon(
                Icons.edit_location_outlined,
                color: AppTheme.sageClair,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
          ),
        ],
      );
    }

    // ── Cas 2 : aucun lieu — bouton d'ajout ───────────────────────────────
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          onPressed: _chargement ? null : _utiliserGPS,
          icon: _chargement
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.sage),
                )
              : const Icon(Icons.my_location_outlined, size: 18),
          label: Text(
            _chargement ? l10n.lieuLocalisation : l10n.lieuUtiliserPosition,
          ),
        ),
        if (_erreur != null) ...[
          const SizedBox(height: 8),
          Text(
            _erreur!,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.red.shade400),
          ),
        ],
      ],
    );
  }
}
