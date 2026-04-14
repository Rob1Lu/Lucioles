import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/entree.dart';
import '../../data/signalement_datasource.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/entrees_provider.dart';
import 'widgets/luciole_marker_widget.dart';

// ─── Helpers de localisation pour les énumérations ───────────────────────────

String _labelPlage(PlageDate plage, AppLocalizations l10n) {
  switch (plage) {
    case PlageDate.aujourdhui:   return l10n.filterToday;
    case PlageDate.semaine:      return l10n.filterWeek;
    case PlageDate.mois:         return l10n.filterMonth;
    case PlageDate.annee:        return l10n.filterYear;
    case PlageDate.personnalisee: return l10n.filterCustom;
  }
}

String _labelCourtPlage(PlageDate plage, AppLocalizations l10n) {
  switch (plage) {
    case PlageDate.aujourdhui:   return l10n.filterTodayShort;
    case PlageDate.semaine:      return l10n.filterWeekShort;
    case PlageDate.mois:         return l10n.filterMonthShort;
    case PlageDate.annee:        return l10n.filterYearShort;
    case PlageDate.personnalisee: return l10n.filterCustomShort;
  }
}

// ─── Modèle des filtres actifs ────────────────────────────────────────────────

/// Encapsule l'état complet des filtres de la carte.
/// Immuable — chaque modification produit une nouvelle instance via [copyWith].
class _FiltresCarte {
  const _FiltresCarte({
    this.plageDate = PlageDate.mois,
    this.plageDateCustom,
    this.uniquementMesLucioles = false,
  });

  /// Plage temporelle sélectionnée
  final PlageDate plageDate;

  /// Plage personnalisée, renseignée uniquement si [plageDate] == personnalisee
  final DateTimeRange? plageDateCustom;

  /// Quand true : n'affiche que les entrées de l'utilisateur.
  /// Placeholder pour une future fonctionnalité sociale — sans effet pour l'instant.
  final bool uniquementMesLucioles;

  /// Indique si les filtres diffèrent des valeurs par défaut
  bool get estNonDefaut =>
      plageDate != PlageDate.mois || uniquementMesLucioles;

  /// Calcule la plage [start, end[ correspondant au mode sélectionné.
  DateTimeRange? get plageEffective {
    final now = DateTime.now();
    final auj = DateTime(now.year, now.month, now.day);

    switch (plageDate) {
      case PlageDate.aujourdhui:
        return DateTimeRange(
          start: auj,
          end: auj.add(const Duration(days: 1)),
        );
      case PlageDate.semaine:
        final lundi = auj.subtract(Duration(days: auj.weekday - 1));
        return DateTimeRange(
          start: lundi,
          end: lundi.add(const Duration(days: 7)),
        );
      case PlageDate.mois:
        return DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 1),
        );
      case PlageDate.annee:
        return DateTimeRange(
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        );
      case PlageDate.personnalisee:
        return plageDateCustom;
    }
  }

  _FiltresCarte copyWith({
    PlageDate? plageDate,
    DateTimeRange? plageDateCustom,
    bool effacerCustom = false,
    bool? uniquementMesLucioles,
  }) =>
      _FiltresCarte(
        plageDate: plageDate ?? this.plageDate,
        plageDateCustom:
            effacerCustom ? null : (plageDateCustom ?? this.plageDateCustom),
        uniquementMesLucioles:
            uniquementMesLucioles ?? this.uniquementMesLucioles,
      );
}

// ─── Écran principal ──────────────────────────────────────────────────────────

/// Carte personnelle — toutes les lucioles géolocalisées sur fond nocturne.
class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  final MapController _mapController = MapController();

  Entree? _entreeSelectionnee;
  Position? _positionAppareil;

  /// Filtres actifs — par défaut : ce mois-ci + uniquement mes lucioles
  _FiltresCarte _filtres = const _FiltresCarte();

  @override
  void initState() {
    super.initState();
    _initialiserPositionAppareil();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Récupère la position de l'appareil si la permission est déjà accordée,
  /// sans jamais afficher de dialogue de demande de permission.
  Future<void> _initialiserPositionAppareil() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) return;

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 5),
        ),
      );
      if (!mounted) return;
      setState(() => _positionAppareil = position);

      // Centrer sur l'appareil seulement si aucune entrée géolocalisée
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final entrees = context.read<EntreesProvider>().entreesGeolocalisees;
        if (entrees.isEmpty) {
          _mapController.move(
            LatLng(position.latitude, position.longitude),
            AppConstants.zoomEntree,
          );
        }
      });
    } catch (_) {
      // GPS indisponible — comportement par défaut
    }
  }

  // ─── Filtrage ──────────────────────────────────────────────────────────────

  /// Applique les filtres actifs à la liste des entrées géolocalisées.
  List<Entree> _filtrerEntrees(List<Entree> entrees) {
    final plage = _filtres.plageEffective;

    return entrees.where((e) {
      if (plage != null) {
        if (e.dateCreation.isBefore(plage.start)) return false;
        if (!e.dateCreation.isBefore(plage.end)) return false;
      }
      return true;
    }).toList();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  void _selectionnerEntree(Entree entree) {
    _mapController.move(
      LatLng(entree.latitude!, entree.longitude!),
      AppConstants.zoomEntree,
    );
    setState(() => _entreeSelectionnee = entree);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BottomSheetEntree(entree: entree),
    ).then((_) {
      if (mounted) setState(() => _entreeSelectionnee = null);
    });
  }

  /// Ouvre le panneau de filtres.
  /// Les changements s'appliquent en temps réel sur la carte (preview live).
  void _ouvrirFiltres() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BottomSheetFiltres(
        filtresInitiaux: _filtres,
        onFiltresChanged: (nouveaux) =>
            setState(() => _filtres = nouveaux),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<EntreesProvider>(
      builder: (context, provider, _) {
        // Source selon le toggle : toutes les lucioles ou uniquement les miennes
        final sourceEntrees = _filtres.uniquementMesLucioles
            ? provider.entreesGeolocalisees
            : provider.toutesGeolocalisees;
        final toutesEntrees = provider.toutesGeolocalisees;
        final entreesFiltrees = _filtrerEntrees(sourceEntrees);

        return Scaffold(
          backgroundColor: AppTheme.nuitProfonde,
          body: Stack(
            children: [
              _buildCarte(entreesFiltrees, toutesEntrees),
              _buildHeader(entreesFiltrees.length, l10n),
              if (entreesFiltrees.isEmpty && !provider.chargement)
                _buildEtatVide(sourceEntrees.isEmpty, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarte(List<Entree> entreesFiltrees, List<Entree> toutes) {
    // Priorité : dernière entrée filtrée > position appareil > dernière entrée
    // globale > centre de la France
    final LatLng centre;
    final double zoom;

    if (entreesFiltrees.isNotEmpty) {
      centre = LatLng(entreesFiltrees.first.latitude!, entreesFiltrees.first.longitude!);
      zoom = AppConstants.zoomEntree;
    } else if (_positionAppareil != null && toutes.isEmpty) {
      centre = LatLng(_positionAppareil!.latitude, _positionAppareil!.longitude);
      zoom = AppConstants.zoomEntree;
    } else if (toutes.isNotEmpty) {
      centre = LatLng(toutes.first.latitude!, toutes.first.longitude!);
      zoom = AppConstants.zoomEntree;
    } else {
      centre = const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude);
      zoom = AppConstants.defaultZoom;
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: centre,
        initialZoom: zoom,
        minZoom: 3,
        maxZoom: 18,
        backgroundColor: AppTheme.nuitProfonde,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.lucioles.app',
          maxNativeZoom: 18,
          tileBuilder: _tileBuilderDouce,
        ),
        MarkerLayer(
          markers: entreesFiltrees.map((entree) {
            return Marker(
              point: LatLng(entree.latitude!, entree.longitude!),
              width: AppConstants.markerSize,
              height: AppConstants.markerSize,
              child: LucioleMarkerWidget(
                isHighlighted: _entreeSelectionnee?.id == entree.id,
                onTap: () => _selectionnerEntree(entree),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Léger réchauffement des tuiles Dark Matter vers un noir cassé brun-charbon.
  Widget _tileBuilderDouce(
    BuildContext context,
    Widget tileWidget,
    TileImage tileImage,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        1.0, 0.0, 0.0, 0, 12,
        0.0, 1.0, 0.0, 0, 5,
        0.0, 0.0, 0.90, 0, 0,
        0.0, 0.0, 0.0, 1, 0,
      ]),
      child: tileWidget,
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(int nombreVisible, AppLocalizations l10n) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Titre
          _PillNuit(
            child: Text(
              l10n.carteMonAtlas,
              style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.creme,
              ),
            ),
          ),

          const Spacer(),

          // Bouton filtres — toujours visible, dot doré si non-défaut
          GestureDetector(
            onTap: _ouvrirFiltres,
            child: _PillNuit(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: _filtres.estNonDefaut
                        ? AppTheme.lucioleOr
                        : AppTheme.cremeFonce.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _labelCourtPlage(_filtres.plageDate, l10n),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _filtres.estNonDefaut
                          ? AppTheme.lucioleOr
                          : AppTheme.cremeFonce,
                    ),
                  ),
                  // Indicateur actif quand filtres non-défaut
                  if (_filtres.estNonDefaut) ...[
                    const SizedBox(width: 5),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lucioleOr,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lucioleOr.withValues(alpha: 0.7),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Compteur de lucioles visibles
          if (nombreVisible > 0) ...[
            const SizedBox(width: 8),
            _PillNuit(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lucioleOr,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lucioleOr.withValues(alpha: 0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$nombreVisible',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.cremeFonce,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── État vide ────────────────────────────────────────────────────────────

  /// [atlasVide] : true si aucune entrée géolocalisée n'existe du tout,
  ///              false si des entrées existent mais sont masquées par les filtres.
  Widget _buildEtatVide(bool atlasVide, AppLocalizations l10n) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppTheme.nuitSurface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '✦',
              style: TextStyle(
                fontSize: 24,
                color: AppTheme.lucioleOr,
                shadows: [
                  Shadow(
                    color: AppTheme.lucioleOr.withValues(alpha: 0.6),
                    blurRadius: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              atlasVide ? l10n.carteAtlasVide : l10n.carteAucunePeriode,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.creme,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              atlasVide ? l10n.carteAtlasVideSub : l10n.carteAucunePeriodeSub,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.cremeFonce.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (!atlasVide) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _filtres = const _FiltresCarte()),
                child: Text(
                  l10n.carteReinitialiserFiltres,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.lucioleOr,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.lucioleOr,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Widget réutilisable : pill nuit ─────────────────────────────────────────

/// Conteneur pill semi-transparent sur fond sombre — partagé par le header.
class _PillNuit extends StatelessWidget {
  const _PillNuit({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.nuitSurface.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Bottom sheet : filtres ───────────────────────────────────────────────────

/// Panneau de filtres de la carte.
///
/// Les changements s'appliquent immédiatement (preview live sur la carte
/// visible en arrière-plan). Aucun bouton "Appliquer" nécessaire.
class _BottomSheetFiltres extends StatefulWidget {
  const _BottomSheetFiltres({
    required this.filtresInitiaux,
    required this.onFiltresChanged,
  });

  final _FiltresCarte filtresInitiaux;
  final void Function(_FiltresCarte) onFiltresChanged;

  @override
  State<_BottomSheetFiltres> createState() => _BottomSheetFiltresState();
}

class _BottomSheetFiltresState extends State<_BottomSheetFiltres> {
  late _FiltresCarte _filtres;

  @override
  void initState() {
    super.initState();
    _filtres = widget.filtresInitiaux;
  }

  /// Met à jour l'état local ET notifie le parent — mise à jour live.
  void _update(_FiltresCarte nouveaux) {
    setState(() => _filtres = nouveaux);
    widget.onFiltresChanged(nouveaux);
  }

  void _reinitialiser() => _update(const _FiltresCarte());

  /// Ouvre le sélecteur de plage de dates native avec un thème sombre.
  Future<void> _ouvrirSelecteurDates() async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _filtres.plageDateCustom ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now(),
          ),
      locale: locale,
      helpText: l10n.carteDatePickerTitre,
      cancelText: l10n.carteDatePickerAnnuler,
      confirmText: l10n.carteDatePickerConfirmer,
      builder: (context, child) {
        // Thème sombre cohérent avec la carte nocturne
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.lucioleOr,
              onPrimary: AppTheme.nuitProfonde,
              surface: AppTheme.nuitSurface,
              onSurface: AppTheme.creme,
              secondaryContainer: AppTheme.lucioleOr.withValues(alpha: 0.2),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppTheme.lucioleOr),
            ),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      _update(_filtres.copyWith(
        plageDate: PlageDate.personnalisee,
        plageDateCustom: range,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.nuitSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 28,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poignée + titre + reset
          _buildEnTete(l10n),

          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section période ──────────────────────────────────────
                _buildTitreSection(l10n.carteFiltresPeriode),
                const SizedBox(height: 12),
                _buildChipsPlage(l10n),

                // ── Sélecteur de dates custom ────────────────────────────
                if (_filtres.plageDate == PlageDate.personnalisee) ...[
                  const SizedBox(height: 12),
                  _buildBoutonDatesCustom(l10n),
                ],

                const SizedBox(height: 20),
                Divider(color: Colors.white.withValues(alpha: 0.08)),
                const SizedBox(height: 16),

                // ── Uniquement mes lucioles ──────────────────────────────
                _buildToggleMesLucioles(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnTete(AppLocalizations l10n) {
    return Column(
      children: [
        // Poignée
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 16, 8),
          child: Row(
            children: [
              Text(
                l10n.carteFiltres,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.creme,
                ),
              ),
              const Spacer(),
              // Bouton réinitialiser — visible seulement si filtres non-défaut
              AnimatedOpacity(
                opacity: _filtres.estNonDefaut ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: TextButton.icon(
                  onPressed: _filtres.estNonDefaut ? _reinitialiser : null,
                  icon: const Icon(Icons.refresh_rounded, size: 14),
                  label: Text(l10n.carteFiltresReinitialiser),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.lucioleOr.withValues(alpha: 0.8),
                    textStyle: GoogleFonts.inter(fontSize: 13),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitreSection(String titre) {
    return Text(
      titre.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppTheme.cremeFonce.withValues(alpha: 0.4),
        letterSpacing: 1.2,
      ),
    );
  }

  /// Chips de sélection de la plage temporelle.
  Widget _buildChipsPlage(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PlageDate.values.map((plage) {
        final selected = _filtres.plageDate == plage;
        return GestureDetector(
          onTap: () {
            if (plage == PlageDate.personnalisee && !selected) {
              // Ouvrir directement le sélecteur de dates au tap
              _update(_filtres.copyWith(
                plageDate: PlageDate.personnalisee,
                effacerCustom: true,
              ));
              _ouvrirSelecteurDates();
            } else {
              _update(_filtres.copyWith(
                plageDate: plage,
                effacerCustom: plage != PlageDate.personnalisee,
              ));
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppTheme.lucioleOr.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected
                    ? AppTheme.lucioleOr.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Text(
              _labelPlage(plage, l10n),
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppTheme.lucioleOr : AppTheme.cremeFonce,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Bouton affiché quand "Personnalisé" est actif pour changer la plage.
  Widget _buildBoutonDatesCustom(AppLocalizations l10n) {
    final localeCode = Localizations.localeOf(context).toString();
    final fmt = DateFormat('d MMM yyyy', localeCode);
    final plage = _filtres.plageDateCustom;

    return GestureDetector(
      onTap: _ouvrirSelecteurDates,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lucioleOr.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 15,
              color: AppTheme.lucioleOr.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                plage != null
                    ? '${fmt.format(plage.start)}  →  ${fmt.format(plage.end)}'
                    : l10n.carteFiltresChoisirDates,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: plage != null
                      ? AppTheme.creme
                      : AppTheme.cremeFonce.withValues(alpha: 0.5),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppTheme.cremeFonce.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleMesLucioles(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.carteFiltresUniquement,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.creme,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.carteFiltresCommunaute,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.cremeFonce.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _filtres.uniquementMesLucioles,
          onChanged: (val) =>
              _update(_filtres.copyWith(uniquementMesLucioles: val)),
          activeThumbColor: AppTheme.lucioleOr,
          activeTrackColor: AppTheme.lucioleOr.withValues(alpha: 0.3),
          inactiveThumbColor: AppTheme.cremeFonce.withValues(alpha: 0.5),
          inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        ),
      ],
    );
  }
}

// ─── Bottom sheet : détail d'une entrée ──────────────────────────────────────

/// Fiche de détails affichée quand l'utilisateur tappe sur une luciole.
class _BottomSheetEntree extends StatelessWidget {
  const _BottomSheetEntree({required this.entree});
  final Entree entree;

  void _ouvrirSignalement(BuildContext context) {
    Navigator.of(context).pop(); // ferme la fiche courante
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _BottomSheetSignalement(entree: entree),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('EEEE d MMMM yyyy', localeCode);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.nuitSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 28,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.lucioleOr,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lucioleOr.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      dateFormat.format(entree.dateCreation),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.cremeFonce.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"${entree.texte}"',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    color: AppTheme.creme,
                    height: 1.7,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (entree.lieuNom != null && entree.lieuNom!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.place_outlined, size: 14, color: AppTheme.terracottaClair),
                      const SizedBox(width: 5),
                      Text(
                        entree.lieuNom!,
                        style: GoogleFonts.inter(fontSize: 13, color: AppTheme.terracottaClair),
                      ),
                    ],
                  ),
                ],
                if (entree.photoUrl != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      entree.photoUrl!,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
                // ── Bouton signalement discret ──────────────────────────
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => _ouvrirSignalement(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 13,
                            color: AppTheme.cremeFonce.withValues(alpha: 0.3),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.signalementSignaler,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.cremeFonce.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom sheet : signalement ──────────────────────────────────────────────

/// Formulaire de signalement d'une luciole.
class _BottomSheetSignalement extends StatefulWidget {
  const _BottomSheetSignalement({required this.entree});
  final Entree entree;

  @override
  State<_BottomSheetSignalement> createState() => _BottomSheetSignalementState();
}

class _BottomSheetSignalementState extends State<_BottomSheetSignalement> {
  final _datasource = SignalementDatasource();
  final _detailsController = TextEditingController();

  String? _raisonSelectionnee;
  bool _loading = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _envoyer() async {
    if (_raisonSelectionnee == null || _loading) return;
    final l10n = AppLocalizations.of(context);

    setState(() => _loading = true);
    try {
      final dejaSignale = await _datasource.aDejaSignale(widget.entree.id);
      if (!mounted) return;

      // Capture le messenger avant tout pop() — le contexte sera détaché ensuite
      final messenger = ScaffoldMessenger.of(context);
      final nav = Navigator.of(context);

      if (dejaSignale) {
        nav.pop();
        messenger.showSnackBar(SnackBar(
          content: Text(l10n.signalementDejaFait),
          backgroundColor: AppTheme.nuitSurface,
        ));
        return;
      }

      await _datasource.signalerEntree(
        entreeId: widget.entree.id,
        raison: _raisonSelectionnee!,
        details: _detailsController.text.trim().isEmpty
            ? null
            : _detailsController.text.trim(),
      );

      if (!mounted) return;
      nav.pop();
      messenger.showSnackBar(SnackBar(
        content: Text(l10n.signalementConfirmation),
        backgroundColor: AppTheme.nuitSurface,
      ));
    } catch (e, stack) {
      debugPrint('[Signalement] Erreur lors du signalement: $e\n$stack');
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.signalementErreur),
        backgroundColor: AppTheme.nuitSurface,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final raisons = [
      ('inapproprie', l10n.signalementRaisonInapproprie),
      ('offensant',   l10n.signalementRaisonOffensant),
      ('spam',        l10n.signalementRaisonSpam),
      ('autre',       l10n.signalementRaisonAutre),
    ];

    // viewInsets.bottom = hauteur du clavier virtuel
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      // Pousse la sheet vers le haut quand le clavier est ouvert
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: AppTheme.nuitSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 28,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Poignée ──────────────────────────────────────────────────
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22, 16, 22, bottomPadding + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── En-tête ──────────────────────────────────────────────
                Text(
                  l10n.signalementTitre,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.creme,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.signalementChoixRaison,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.cremeFonce.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),

                // ── Chips de raison ──────────────────────────────────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: raisons.map((item) {
                    final (code, label) = item;
                    final selected = _raisonSelectionnee == code;
                    return GestureDetector(
                      onTap: () => setState(() => _raisonSelectionnee = code),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.terracotta.withValues(alpha: 0.18)
                              : Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? AppTheme.terracotta.withValues(alpha: 0.6)
                                : Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Text(
                          label,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: selected
                                ? AppTheme.terracottaClair
                                : AppTheme.cremeFonce,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // ── Champ détails ────────────────────────────────────────
                if (_raisonSelectionnee != null) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _detailsController,
                    maxLength: 150,
                    maxLines: 3,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.creme,
                    ),
                    decoration: InputDecoration(
                      hintText: l10n.signalementDetailsHint,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.cremeFonce.withValues(alpha: 0.35),
                      ),
                      labelText: l10n.signalementDetails,
                      labelStyle: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.cremeFonce.withValues(alpha: 0.5),
                      ),
                      counterStyle: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.cremeFonce.withValues(alpha: 0.3),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.04),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.cremeFonce.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // ── Boutons ──────────────────────────────────────────────
                Row(
                  children: [
                    TextButton(
                      onPressed:
                          _loading ? null : () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            AppTheme.cremeFonce.withValues(alpha: 0.6),
                        textStyle: GoogleFonts.inter(fontSize: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text(l10n.carteDatePickerAnnuler),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed:
                          (_raisonSelectionnee == null || _loading)
                              ? null
                              : _envoyer,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.terracotta,
                        disabledBackgroundColor:
                            AppTheme.terracotta.withValues(alpha: 0.3),
                        foregroundColor: AppTheme.creme,
                        disabledForegroundColor:
                            AppTheme.creme.withValues(alpha: 0.4),
                        textStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.signalementEnvoyer),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),         // Column (SingleChildScrollView)
    ),           // SingleChildScrollView
    ),           // Container
    );           // Padding (keyboard offset)
  }
}
