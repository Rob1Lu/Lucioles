import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants.dart';
import '../../core/supabase_config.dart';
import '../../core/theme.dart';
import '../../core/ui_helpers.dart';
import '../../data/models/entree.dart';
import '../../features/auth/auth_screen.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/entrees_provider.dart';
import '../feedback/feedback_bottom_sheet.dart';
import 'widgets/champ_lieu_widget.dart';

/// Écran de saisie quotidienne.
///
/// Affiche le formulaire si l'utilisateur n'a pas encore écrit aujourd'hui.
/// Sinon, affiche la luciole du jour de façon contemplative.
class SaisieScreen extends StatefulWidget {
  const SaisieScreen({super.key});

  @override
  State<SaisieScreen> createState() => _SaisieScreenState();
}

class _SaisieScreenState extends State<SaisieScreen> {
  final _formKey = GlobalKey<FormState>();
  final _texteController = TextEditingController();
  final _uuid = const Uuid();
  final _imagePicker = ImagePicker();

  LieuData? _lieu;
  XFile? _photoSelectionnee;
  bool _enCoursDeSauvegarde = false;
  bool _enCoursAjoutPhoto = false;

  @override
  void dispose() {
    _texteController.dispose();
    super.dispose();
  }

  // ─── Gestion de la photo ─────────────────────────────────────────────────

  Future<void> _selectionnerPhoto() async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (photo != null) setState(() => _photoSelectionnee = photo);
  }

  /// Uploade la photo dans Supabase Storage et retourne le chemin Storage.
  Future<String> _uploaderPhoto(XFile photo, String entreeId) async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser!.id;
    final ext = p.extension(photo.path).toLowerCase();
    final storagePath = '$userId/$entreeId$ext';
    final bytes = await photo.readAsBytes();
    await client.storage
        .from(SupabaseConfig.bucketEntreePhotos)
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: FileOptions(contentType: _mimeType(ext)),
        );
    return storagePath;
  }

  String _mimeType(String ext) {
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  /// Permet d'ajouter une photo à une entrée déjà publiée (sans photo).
  Future<void> _ajouterPhotoAposteriori(Entree entree) async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (photo == null || !mounted) return;

    setState(() => _enCoursAjoutPhoto = true);
    try {
      final storagePath = await _uploaderPhoto(photo, entree.id);
      if (!mounted) return;
      await context.read<EntreesProvider>().updatePhotoUrl(
        entree.id,
        storagePath,
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(buildStyledSnackBar(l10n.saisieAjoutPhotoConfirmation));
    } finally {
      if (mounted) setState(() => _enCoursAjoutPhoto = false);
    }
  }

  // ─── Sauvegarde de l'entrée ───────────────────────────────────────────────

  Future<void> _sauvegarder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enCoursDeSauvegarde = true);

    try {
      final entreeId = _uuid.v4();
      String? photoUrl;
      if (_photoSelectionnee != null) {
        photoUrl = await _uploaderPhoto(_photoSelectionnee!, entreeId);
      }

      final entree = Entree(
        id: entreeId,
        texte: _texteController.text.trim(),
        latitude: _lieu?.latitude,
        longitude: _lieu?.longitude,
        lieuNom: _lieu?.nom,
        photoUrl: photoUrl,
        dateCreation: DateTime.now(),
      );

      if (!mounted) return;
      await context.read<EntreesProvider>().ajouter(entree);

      if (!mounted) return;
      _afficherConfirmation();
    } finally {
      if (mounted) setState(() => _enCoursDeSauvegarde = false);
    }
  }

  void _afficherConfirmation() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(buildStyledSnackBar(l10n.saisieConfirmation));
  }

  // ─── Construction de l'UI ─────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, EntreesProvider>(
      builder: (context, auth, provider, _) {
        // ── Pas connecté → gate d'authentification ──────────────────────────
        if (!auth.estConnecte) {
          return _buildAuthGate();
        }

        if (provider.chargement) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.sage),
          );
        }

        // Entrée déjà créée aujourd'hui — vue contemplative
        if (provider.dejaEntreeCeJour && provider.entreeJour != null) {
          return _buildVueExistante(provider.entreeJour!);
        }

        // Formulaire de saisie
        return _buildFormulaire();
      },
    );
  }

  /// Écran affiché quand l'utilisateur n'est pas connecté.
  /// Explique pourquoi un compte est nécessaire et propose de s'authentifier.
  Widget _buildAuthGate() {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(l10n.saisieAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined),
            tooltip: l10n.feedbackBouton,
            onPressed: () => FeedbackBottomSheet.show(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Luciole décorative
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.lucioleOr.withValues(alpha: 0.08),
              ),
              child: Center(
                child: Text(
                  '✦',
                  style: TextStyle(
                    fontSize: 34,
                    color: AppTheme.lucioleOr,
                    shadows: [
                      Shadow(
                        color: AppTheme.lucioleOr.withValues(alpha: 0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text(
              l10n.authGateTitre,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textePrincipal,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              l10n.authGateSousTitre,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.texteSecondaire,
                height: 1.7,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AuthScreen(peutFermer: true),
                  ),
                ),
                child: Text(l10n.authGateBouton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vue affichée quand l'entrée du jour est déjà enregistrée.
  Widget _buildVueExistante(Entree entree) {
    final l10n = AppLocalizations.of(context);
    final localeCode = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat('EEEE d MMMM', localeCode);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(l10n.saisieAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined),
            tooltip: l10n.feedbackBouton,
            onPressed: () => FeedbackBottomSheet.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge luciole du jour
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.sagePale,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _LucioleDot(),
                  const SizedBox(width: 8),
                  Text(
                    l10n.saisieBadgeDuJour,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.sage,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Date
            Text(
              dateFormat.format(entree.dateCreation),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 16),

            // Texte de l'entrée en serif
            Text(
              '"${entree.texte}"',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppTheme.textePrincipal,
              ),
            ),

            // Lieu si présent
            if (entree.aLieu) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: AppTheme.terracotta,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entree.lieuAffichage,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.terracotta,
                    ),
                  ),
                ],
              ),
            ],

            // Photo si présente
            if (entree.photoUrl != null) ...[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  entree.photoUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            const SizedBox(height: 40),

            // Message de retour
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.saisieDejaFaite,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.texteTertaire,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            // Bouton d'ajout de photo — uniquement si aucune photo n'existe encore
            if (entree.photoUrl == null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _enCoursAjoutPhoto
                      ? null
                      : () => _ajouterPhotoAposteriori(entree),
                  icon: _enCoursAjoutPhoto
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.sage,
                          ),
                        )
                      : const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(l10n.saisieAjouterPhotoAposteriori),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Formulaire de création d'une nouvelle entrée.
  Widget _buildFormulaire() {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(l10n.saisieAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.rate_review_outlined),
            tooltip: l10n.feedbackBouton,
            onPressed: () => FeedbackBottomSheet.show(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête poétique
              Text(
                l10n.saisieQuestion,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.saisieSubtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),

              // ── Champ texte principal ────────────────────────────────────
              _buildChampTexte(l10n),
              const SizedBox(height: 28),

              // ── Séparateur visuel ────────────────────────────────────────
              _buildSeparateur(l10n.saisieLieuLabel),
              const SizedBox(height: 14),

              ChampLieuWidget(
                onLieuChanged: (lieu) => setState(() => _lieu = lieu),
              ),
              const SizedBox(height: 28),

              // ── Photo optionnelle ────────────────────────────────────────
              _buildSeparateur(l10n.saisiePhotoLabel),
              const SizedBox(height: 14),

              _buildSelectionPhoto(l10n),
              const SizedBox(height: 40),

              // ── Bouton de sauvegarde ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _enCoursDeSauvegarde ? null : _sauvegarder,
                  child: _enCoursDeSauvegarde
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.saisieButtonAllumer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChampTexte(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFormField(
          controller: _texteController,
          maxLength: AppConstants.maxCaracteres,
          maxLines: 5,
          minLines: 3,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  null, // Compteur personnalisé ci-dessous
          style: GoogleFonts.playfairDisplay(
            fontSize: 17,
            color: AppTheme.textePrincipal,
            height: 1.7,
          ),
          decoration: InputDecoration(hintText: l10n.saisieHint),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.saisieValidator;
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 4),
        // Compteur de caractères personnalisé
        ListenableBuilder(
          listenable: _texteController,
          builder: (context, child) {
            final count = _texteController.text.length;
            final pres = count > AppConstants.maxCaracteres - 20;
            return Text(
              '$count / ${AppConstants.maxCaracteres}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: pres ? AppTheme.terracotta : AppTheme.texteTertaire,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSeparateur(String label) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: AppTheme.texteSecondaire),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSelectionPhoto(AppLocalizations l10n) {
    if (_photoSelectionnee != null) {
      // Prévisualisation de la photo sélectionnée
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.file(
              File(_photoSelectionnee!.path),
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // Bouton de suppression de la photo
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() => _photoSelectionnee = null),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      );
    }

    // Bouton pour ouvrir la galerie
    return OutlinedButton.icon(
      onPressed: _selectionnerPhoto,
      icon: const Icon(Icons.photo_library_outlined, size: 18),
      label: Text(l10n.saisieAjouterPhoto),
    );
  }
}

/// Petit point doré animé utilisé dans la vue "entrée existante"
class _LucioleDot extends StatelessWidget {
  const _LucioleDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.lucioleOr,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lucioleHalo,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
