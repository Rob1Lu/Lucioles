import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../core/ui_helpers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/locale_provider.dart';

class ParametresCompteScreen extends StatefulWidget {
  const ParametresCompteScreen({super.key});

  @override
  State<ParametresCompteScreen> createState() => _ParametresCompteScreenState();
}

class _ParametresCompteScreenState extends State<ParametresCompteScreen> {
  bool _googleEstaitLie = false;
  late AuthProvider _authRef;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _authRef = context.read<AuthProvider>();
      _googleEstaitLie = _aGoogleIdentity(_authRef);
      _authRef.addListener(_onAuthChanged);
    });
  }

  bool _aGoogleIdentity(AuthProvider auth) =>
      auth.utilisateur?.identities?.any((i) => i.provider == 'google') ?? false;

  void _onAuthChanged() {
    final maintenant = _aGoogleIdentity(_authRef);
    if (!_googleEstaitLie && maintenant && mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        buildStyledSnackBar(
          l10n.profilLierGoogleConfirmation,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    _googleEstaitLie = maintenant;
  }

  @override
  void dispose() {
    _authRef.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _confirmerDeconnexion() {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.authSeDeconnecter,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
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
              Navigator.of(context).pop();
              context.read<AuthProvider>().seDeconnecter();
            },
            child: Text(
              l10n.authSeDeconnecter,
              style: GoogleFonts.inter(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmerSuppressionCompte() {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.profilSupprimerTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          l10n.profilSupprimerMessage,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.texteSecondaire,
            height: 1.5,
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
              context.read<AuthProvider>().supprimerCompte();
            },
            child: Text(
              l10n.profilSupprimerConfirmer,
              style: GoogleFonts.inter(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer2<AuthProvider, LocaleProvider>(
      builder: (context, authProvider, localeProvider, _) {
        return Scaffold(
          backgroundColor: AppTheme.creme,
          appBar: AppBar(
            title: Text(l10n.profilParametresCompte),
            backgroundColor: AppTheme.creme,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
          ),
          body: ListView(
            children: [
              _SectionLierGoogle(authProvider: authProvider, l10n: l10n),
              _SectionLangue(localeProvider: localeProvider, l10n: l10n),
              _SectionZoneSensible(
                l10n: l10n,
                chargement: authProvider.chargement,
                onDeconnexion: _confirmerDeconnexion,
                onSupprimerCompte: _confirmerSuppressionCompte,
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

// ─── Section connexion (comptes liés) ────────────────────────────────────────

class _SectionLierGoogle extends StatelessWidget {
  const _SectionLierGoogle({
    required this.authProvider,
    required this.l10n,
  });

  final AuthProvider authProvider;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final identities = authProvider.utilisateur?.identities ?? [];
    final googleIdentity =
        identities.where((i) => i.provider == 'google').firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitreSectionParams(titre: l10n.profilConnexion),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cremeTres),
          ),
          child: Column(
            children: [
              _LigneProvider(
                icon: _GoogleIconProfil(),
                titre: googleIdentity != null
                    ? l10n.profilCompteLie
                    : l10n.profilLierGoogle,
                sousTitre: googleIdentity?.identityData?['email'] as String?,
                estLie: googleIdentity != null,
                chargement: authProvider.chargement,
                isFirst: true,
                isLast: false,
                onTap: googleIdentity != null
                    ? null
                    : () => authProvider.lierGoogle(),
              ),
              Divider(
                height: 1,
                indent: 18,
                endIndent: 18,
                color: AppTheme.cremeTres,
              ),
              _LigneProvider(
                icon: const Icon(
                  Icons.apple_rounded,
                  size: 20,
                  color: AppTheme.texteSecondaire,
                ),
                titre: l10n.profilLierApple,
                sousTitre: null,
                estLie: false,
                chargement: false,
                isFirst: false,
                isLast: true,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  buildStyledSnackBar(
                    l10n.profilAppleBientot,
                    duration: const Duration(seconds: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LigneProvider extends StatelessWidget {
  const _LigneProvider({
    required this.icon,
    required this.titre,
    required this.sousTitre,
    required this.estLie,
    required this.chargement,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final Widget icon;
  final String titre;
  final String? sousTitre;
  final bool estLie;
  final bool chargement;
  final bool isFirst;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: chargement ? null : onTap,
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            SizedBox(width: 22, child: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: onTap != null && !estLie
                          ? AppTheme.sage
                          : AppTheme.textePrincipal,
                    ),
                  ),
                  if (sousTitre != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      sousTitre!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.texteSecondaire,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (chargement)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.sage,
                ),
              )
            else if (estLie)
              Icon(Icons.check_circle_rounded, size: 18, color: AppTheme.sage)
            else if (onTap != null)
              Icon(Icons.add_rounded, size: 18, color: AppTheme.texteTertaire)
            else
              Icon(Icons.schedule_rounded, size: 16, color: AppTheme.texteTertaire),
          ],
        ),
      ),
    );
  }
}

class _GoogleIconProfil extends StatelessWidget {
  const _GoogleIconProfil();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
          height: 1,
        ),
      ),
    );
  }
}

// ─── Section langue ───────────────────────────────────────────────────────────

class _SectionLangue extends StatelessWidget {
  const _SectionLangue({required this.localeProvider, required this.l10n});

  final LocaleProvider localeProvider;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitreSectionParams(titre: l10n.profilLangueSection),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cremeTres),
          ),
          child: Column(
            children: LocaleProvider.supportedLocales.map((locale) {
              final code = locale.languageCode;
              final isSelected = localeProvider.locale.languageCode == code;
              final isLast = locale == LocaleProvider.supportedLocales.last;
              return Column(
                children: [
                  InkWell(
                    onTap: () => localeProvider.setLocale(locale),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      child: Row(
                        children: [
                          Text(LocaleProvider.drapeaux[code] ?? '',
                              style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 14),
                          Text(
                            LocaleProvider.nomLangues[code] ?? code,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppTheme.textePrincipal
                                  : AppTheme.texteSecondaire,
                            ),
                          ),
                          const Spacer(),
                          AnimatedOpacity(
                            opacity: isSelected ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(Icons.check_rounded,
                                size: 18, color: AppTheme.sage),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 56, color: AppTheme.cremeTres),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Section zone sensible ────────────────────────────────────────────────────

class _SectionZoneSensible extends StatelessWidget {
  const _SectionZoneSensible({
    required this.l10n,
    required this.chargement,
    required this.onDeconnexion,
    required this.onSupprimerCompte,
  });

  final AppLocalizations l10n;
  final bool chargement;
  final VoidCallback onDeconnexion;
  final VoidCallback onSupprimerCompte;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitreSectionParams(titre: l10n.profilZoneSensible),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cremeTres),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: chargement ? null : onDeconnexion,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded,
                          size: 18, color: AppTheme.texteSecondaire),
                      const SizedBox(width: 12),
                      Text(
                        l10n.authSeDeconnecter,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppTheme.textePrincipal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, indent: 18, endIndent: 18,
                  color: AppTheme.cremeTres),
              InkWell(
                onTap: chargement ? null : onSupprimerCompte,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 18, color: Colors.red.shade400),
                      const SizedBox(width: 12),
                      Text(
                        l10n.profilSupprimerCompte,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.red.shade400,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── Titre de section ─────────────────────────────────────────────────────────

class _TitreSectionParams extends StatelessWidget {
  const _TitreSectionParams({required this.titre});
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
