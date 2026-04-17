import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/entree.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/fil/widgets/entree_card_widget.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/entrees_provider.dart';
import '../../shared/providers/admin_provider.dart';
import '../feedback/feedback_bottom_sheet.dart';
import '../../shared/providers/profile_provider.dart';
import '../admin/admin_portal_screen.dart';
import '../aide/aide_screen.dart';
import 'parametres_compte_screen.dart';

/// Écran Profil — troisième onglet.
class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  Saison _filtreSaison = Saison.toutes;
  final _imagePicker = ImagePicker();

  // ─── Helpers de localisation ───────────────────────────────────────────────

  String _labelSaison(Saison s, AppLocalizations l10n) {
    switch (s) {
      case Saison.toutes:    return l10n.saisonToutes;
      case Saison.printemps: return l10n.saisonPrintemps;
      case Saison.ete:       return l10n.saisonEte;
      case Saison.automne:   return l10n.saisonAutomne;
      case Saison.hiver:     return l10n.saisonHiver;
    }
  }

  List<Entree> _filtrerParSaison(List<Entree> entrees) {
    if (_filtreSaison == Saison.toutes) return entrees;
    return entrees.where((e) => e.saison == _filtreSaison).toList();
  }

  // ─── Actions profil ───────────────────────────────────────────────────────

  Future<void> _selectionnerAvatar() async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 400,
      maxHeight: 400,
      imageQuality: 80,
    );
    if (photo != null && mounted) {
      await context.read<ProfileProvider>().updateAvatar(photo);
    }
  }

  void _afficherDialoguePseudo(String? pseudoActuel) {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: pseudoActuel ?? '');

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.profilModifierPseudo,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 30,
          style: GoogleFonts.inter(fontSize: 15, color: AppTheme.textePrincipal),
          decoration: InputDecoration(
            hintText: l10n.profilPseudo,
            hintStyle: GoogleFonts.inter(color: AppTheme.texteTertaire),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              l10n.filSupprimerAnnuler,
              style: GoogleFonts.inter(color: AppTheme.texteSecondaire),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ProfileProvider>().updateUsername(controller.text);
            },
            child: Text(
              l10n.profilSauvegarder,
              style: GoogleFonts.inter(
                color: AppTheme.sage,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Confirmation de suppression d'entrée ─────────────────────────────────

  void _confirmerSuppression(
    BuildContext context,
    AppLocalizations l10n,
    EntreesProvider provider,
    Entree entree,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.filSupprimerTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          l10n.filSupprimerContenu,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.texteSecondaire,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.filSupprimerAnnuler,
                style: GoogleFonts.inter(color: AppTheme.texteSecondaire)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.supprimer(entree.id);
            },
            child: Text(l10n.filSupprimerConfirmer,
                style: GoogleFonts.inter(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer3<EntreesProvider, AuthProvider, ProfileProvider>(
      builder: (context, entreesProvider, authProvider, profileProvider, _) {
        final entrees = entreesProvider.entrees;
        final entreesFiltrees = _filtrerParSaison(entrees);

        return Scaffold(
          backgroundColor: AppTheme.creme,
          body: CustomScrollView(
            slivers: [
              // ── App bar ───────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                title: Text(l10n.profilTitle),
                backgroundColor: AppTheme.creme,
                scrolledUnderElevation: 1,
                shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.rate_review_outlined),
                    tooltip: l10n.feedbackBouton,
                    onPressed: () => FeedbackBottomSheet.show(context),
                  ),
                ],
              ),

              // ── Section compte (connecté ou non) ──────────────────────────
              SliverToBoxAdapter(
                child: _SectionCompte(
                  authProvider: authProvider,
                  profileProvider: profileProvider,
                  l10n: l10n,
                  onAvatarTap: _selectionnerAvatar,
                  onEditPseudoTap: () =>
                      _afficherDialoguePseudo(profileProvider.username),
                ),
              ),

              // ── Bouton paramètres du compte ───────────────────────────────
              if (authProvider.estConnecte)
                SliverToBoxAdapter(
                  child: _BoutonParametres(l10n: l10n),
                ),

              // ── Bouton portail admin (admins uniquement) ──────────────────
              if (profileProvider.isAdmin)
                SliverToBoxAdapter(
                  child: _BoutonAdmin(l10n: l10n),
                ),

              // ── Bouton aide (toujours visible) ────────────────────────────
              SliverToBoxAdapter(
                child: _BoutonAide(l10n: l10n),
              ),

              // ── Stats ─────────────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _StatsCard(entrees: entrees, l10n: l10n),
              ),

              // ── Fil du temps — en-tête ────────────────────────────────────
              SliverToBoxAdapter(
                child: _FilHeader(
                  l10n: l10n,
                  filtreSaison: _filtreSaison,
                  labelSaison: _labelSaison,
                  onFiltreSaisonChange: (s) =>
                      setState(() => _filtreSaison = s),
                ),
              ),

              // ── Fil du temps — liste ──────────────────────────────────────
              if (entreesFiltrees.isEmpty)
                SliverToBoxAdapter(
                  child: _EtatVideFil(
                    filtreSaison: _filtreSaison,
                    labelSaison: _labelSaison,
                    l10n: l10n,
                  ),
                )
              else
                SliverList.builder(
                  itemCount: entreesFiltrees.length,
                  itemBuilder: (context, index) {
                    final entree = entreesFiltrees[index];
                    final showAnnee = index == 0 ||
                        entreesFiltrees[index - 1].dateCreation.year !=
                            entree.dateCreation.year;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showAnnee)
                          _SeparateurAnnee(annee: entree.dateCreation.year),
                        EntreeCardWidget(
                          entree: entree,
                          onSupprimerDemande: () => _confirmerSuppression(
                            context, l10n, entreesProvider, entree,
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section compte ───────────────────────────────────────────────────────────

class _SectionCompte extends StatelessWidget {
  const _SectionCompte({
    required this.authProvider,
    required this.profileProvider,
    required this.l10n,
    required this.onAvatarTap,
    required this.onEditPseudoTap,
  });

  final AuthProvider authProvider;
  final ProfileProvider profileProvider;
  final AppLocalizations l10n;
  final VoidCallback onAvatarTap;
  final VoidCallback onEditPseudoTap;

  @override
  Widget build(BuildContext context) {
    if (authProvider.estConnecte) return _buildConnecte(context);
    return _buildNonConnecte(context);
  }

  Widget _buildConnecte(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              children: [
                _AvatarCircle(
                  signedUrl: profileProvider.avatarSignedUrl,
                  chargement: profileProvider.chargement,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.sage,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // ── Pseudo + email ───────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onEditPseudoTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          profileProvider.username ?? l10n.profilAjouterPseudo,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: profileProvider.username != null
                                ? AppTheme.textePrincipal
                                : AppTheme.texteTertaire,
                            fontStyle: profileProvider.username != null
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit_outlined,
                        size: 12,
                        color: AppTheme.texteTertaire,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  authProvider.email ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.texteTertaire,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonConnecte(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lucioleOr.withValues(alpha: 0.07),
            AppTheme.sagePale.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profilNonConnecteTitre,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textePrincipal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profilNonConnecteSousTitre,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.texteSecondaire,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AuthScreen(peutFermer: true),
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle:
                  GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            child: Text(l10n.profilNonConnecteBouton),
          ),
        ],
      ),
    );
  }
}

// ─── Bouton vers les paramètres du compte ─────────────────────────────────────

class _BoutonParametres extends StatelessWidget {
  const _BoutonParametres({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ParametresCompteScreen(),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.settings_outlined,
                  size: 18, color: AppTheme.texteSecondaire),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.profilParametresCompte,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textePrincipal,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppTheme.texteTertaire),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bouton portail admin ─────────────────────────────────────────────────────

class _BoutonAdmin extends StatelessWidget {
  const _BoutonAdmin({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      decoration: BoxDecoration(
        color: AppTheme.sage.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (_) => AdminProvider(),
              child: const AdminPortalScreen(),
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.admin_panel_settings_outlined,
                  size: 18, color: AppTheme.sage),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.adminAccesBouton,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.sage,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppTheme.sage.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bouton aide ──────────────────────────────────────────────────────────────

class _BoutonAide extends StatelessWidget {
  const _BoutonAide({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AideScreen()),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.help_outline_rounded,
                  size: 18, color: AppTheme.texteSecondaire),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.aideAccesBouton,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textePrincipal,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppTheme.texteTertaire),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Avatar circle ────────────────────────────────────────────────────────────

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.signedUrl, required this.chargement});

  final String? signedUrl;
  final bool chargement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.sagePale,
        border: Border.all(
            color: AppTheme.sageClair.withValues(alpha: 0.4), width: 1.5),
      ),
      child: ClipOval(
        child: chargement
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.sage,
                  ),
                ),
              )
            : signedUrl != null
                ? Image.network(
                    signedUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) =>
                        const _AvatarPlaceholder(),
                  )
                : const _AvatarPlaceholder(),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.person_rounded, size: 26, color: AppTheme.sage),
    );
  }
}

// ─── Widgets internes ─────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.entrees, required this.l10n});

  final List<Entree> entrees;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final premierDate = entrees.isNotEmpty
        ? DateFormat('d MMMM yyyy', Localizations.localeOf(context).toString())
            .format(entrees.last.dateCreation)
        : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sage.withValues(alpha: 0.15),
            AppTheme.lucioleOr.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${entrees.length}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrincipal,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.profilStatsSection,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.texteSecondaire,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (premierDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.profilDepuis(premierDate),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.texteTertaire,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          Text(
            '✦',
            style: TextStyle(
              fontSize: 40,
              color: AppTheme.lucioleOr,
              shadows: [
                Shadow(
                  color: AppTheme.lucioleOr.withValues(alpha: 0.5),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilHeader extends StatelessWidget {
  const _FilHeader({
    required this.l10n,
    required this.filtreSaison,
    required this.labelSaison,
    required this.onFiltreSaisonChange,
  });

  final AppLocalizations l10n;
  final Saison filtreSaison;
  final String Function(Saison, AppLocalizations) labelSaison;
  final void Function(Saison) onFiltreSaisonChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitreSectionProfil(titre: l10n.profilFilSection),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 8),
            children: Saison.values.map((saison) {
              final selected = filtreSaison == saison;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(labelSaison(saison, l10n)),
                  selected: selected,
                  onSelected: (_) => onFiltreSaisonChange(saison),
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? AppTheme.sage : AppTheme.texteSecondaire,
                  ),
                  backgroundColor: AppTheme.cremeFonce,
                  selectedColor: AppTheme.sagePale,
                  checkmarkColor: AppTheme.sage,
                  side: BorderSide(
                    color: selected ? AppTheme.sage : Colors.transparent,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

class _EtatVideFil extends StatelessWidget {
  const _EtatVideFil({
    required this.filtreSaison,
    required this.labelSaison,
    required this.l10n,
  });

  final Saison filtreSaison;
  final String Function(Saison, AppLocalizations) labelSaison;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final estFiltre = filtreSaison != Saison.toutes;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: Column(
        children: [
          Text('✦', style: TextStyle(fontSize: 28, color: AppTheme.lucioleOr)),
          const SizedBox(height: 16),
          Text(
            estFiltre
                ? l10n.filVideFiltre(
                    labelSaison(filtreSaison, l10n).toLowerCase())
                : l10n.filVide,
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppTheme.textePrincipal,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            estFiltre ? l10n.filVideFiltreSub : l10n.filVideSub,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.texteSecondaire,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SeparateurAnnee extends StatelessWidget {
  const _SeparateurAnnee({required this.annee});
  final int annee;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      child: Row(
        children: [
          Text(
            annee.toString(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.texteTertaire,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }
}

class _TitreSectionProfil extends StatelessWidget {
  const _TitreSectionProfil({required this.titre});
  final String titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        titre.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.texteTertaire,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
