import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../core/supabase_config.dart';
import '../../core/theme.dart';
import '../../core/ui_helpers.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_provider.dart';
import 'widgets/auth_social_button.dart';

/// Écran d'authentification — connexion et inscription.
///
/// Peut être poussé sur la pile de navigation ou affiché en plein écran.
/// [peutFermer] : true si l'utilisateur peut revenir en arrière sans s'authentifier.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.peutFermer = true});

  final bool peutFermer;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _motDePasseCtrl = TextEditingController();

  bool _modeInscription = false;
  bool _motDePasseVisible = false;
  late AuthProvider _authRef;

  @override
  void initState() {
    super.initState();
    // Écoute les changements d'auth pour fermer l'écran dès que la session
    // est établie — le onAuthStateChange Supabase est async, donc la vérification
    // directe après sInscrire/seConnecter peut arriver trop tôt.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _authRef = context.read<AuthProvider>();
      _authRef.addListener(_onAuthChanged);
    });
  }

  void _onAuthChanged() {
    if (mounted && _authRef.estConnecte) {
      _authRef.removeListener(_onAuthChanged);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _authRef.removeListener(_onAuthChanged);
    _emailCtrl.dispose();
    _motDePasseCtrl.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _soumettre(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    auth.effacerErreur();

    if (_modeInscription) {
      await auth.sInscrire(
        email: _emailCtrl.text.trim(),
        password: _motDePasseCtrl.text,
      );
    } else {
      await auth.seConnecter(
        email: _emailCtrl.text.trim(),
        password: _motDePasseCtrl.text,
      );
    }
    // La redirection est gérée par _onAuthChanged — pas besoin de vérifier ici
  }

  void _basculerMode() {
    setState(() {
      _modeInscription = !_modeInscription;
    });
    // Efface les erreurs au changement de mode
    context.read<AuthProvider>().effacerErreur();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          backgroundColor: AppTheme.creme,
          appBar: widget.peutFermer
              ? AppBar(
                  backgroundColor: AppTheme.creme,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppTheme.texteTertaire,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // ── Luciole décorative ────────────────────────────────
                  _buildLucioleDecoration(),
                  const SizedBox(height: 28),

                  // ── Titre + sous-titre ────────────────────────────────
                  Text(
                    l10n.authBienvenue,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textePrincipal,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authSousTitre,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.texteSecondaire,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),

                  // ── Formulaire email + mot de passe ───────────────────
                  if (SupabaseConfig.authEmailActif) ...[
                    _buildFormulaire(l10n, auth),
                    const SizedBox(height: 16),
                    if (auth.erreur != null) _buildMessageErreur(auth.erreur!),
                    const SizedBox(height: 20),
                    _buildBoutonPrincipal(l10n, auth),
                    const SizedBox(height: 28),
                  ],

                  // ── Message d'erreur hors formulaire (sociaux seuls) ──
                  if (!SupabaseConfig.authEmailActif && auth.erreur != null) ...[
                    _buildMessageErreur(auth.erreur!),
                    const SizedBox(height: 16),
                  ],

                  // ── Séparateur "ou" — uniquement si email ET sociaux ──
                  if (SupabaseConfig.authEmailActif &&
                      (SupabaseConfig.authGoogleActif ||
                          (SupabaseConfig.authAppleActif && Platform.isIOS))) ...[
                    _buildSeparateurOu(l10n),
                    const SizedBox(height: 20),
                  ],

                  // ── Boutons sociaux ───────────────────────────────────
                  _buildBoutonsSociaux(l10n, auth),
                  const SizedBox(height: 32),

                  // ── Bascule mode connexion / inscription ──────────────
                  if (SupabaseConfig.authEmailActif) _buildBasculeMode(l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Widgets internes ─────────────────────────────────────────────────────

  Widget _buildLucioleDecoration() {
    return SvgPicture.asset(
      'lib/assets/icons/lucioles_icon.svg',
      width: 90,
      height: 90,
    );
  }

  Widget _buildFormulaire(AppLocalizations l10n, AuthProvider auth) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // ── Email ──────────────────────────────────────────────────
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textePrincipal,
            ),
            decoration: InputDecoration(
              labelText: l10n.authEmail,
              prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return l10n.authErreurEmailVide;
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                return l10n.authErreurEmailInvalide;
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // ── Mot de passe ───────────────────────────────────────────
          TextFormField(
            controller: _motDePasseCtrl,
            obscureText: !_motDePasseVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _soumettre(auth),
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textePrincipal,
            ),
            decoration: InputDecoration(
              labelText: l10n.authMotDePasse,
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _motDePasseVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppTheme.texteTertaire,
                ),
                onPressed: () =>
                    setState(() => _motDePasseVisible = !_motDePasseVisible),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.authErreurMotDePasseCourt;
              if (v.length < 6) return l10n.authErreurMotDePasseCourt;
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageErreur(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: Colors.red.shade700,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildBoutonPrincipal(AppLocalizations l10n, AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: auth.chargement ? null : () => _soumettre(auth),
        child: auth.chargement
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                _modeInscription ? l10n.authSInscrire : l10n.authSeConnecter,
              ),
      ),
    );
  }

  Widget _buildSeparateurOu(AppLocalizations l10n) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.authOu,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.texteTertaire,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildBoutonsSociaux(AppLocalizations l10n, AuthProvider auth) {
    final showApple = SupabaseConfig.authAppleActif && Platform.isIOS;
    if (!SupabaseConfig.authGoogleActif && !showApple) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        if (SupabaseConfig.authGoogleActif)
          AuthSocialButton(
            label: l10n.authContinuerGoogle,
            icon: _GoogleIcon(),
            onTap: auth.chargement ? null : () => auth.seConnecterGoogle(),
          ),
        if (showApple) ...[
          if (SupabaseConfig.authGoogleActif) const SizedBox(height: 10),
          AuthSocialButton(
            label: l10n.authContinuerApple,
            icon: const Icon(Icons.apple_rounded, size: 20),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              buildStyledSnackBar(
                l10n.authAppleBientot,
                duration: const Duration(seconds: 2),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBasculeMode(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _modeInscription ? l10n.authDejaUnCompte : l10n.authPasDeCompte,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.texteSecondaire,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: _basculerMode,
          child: Text(
            _modeInscription
                ? l10n.authLienSeConnecter
                : l10n.authLienCreerCompte,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.sage,
              decoration: TextDecoration.underline,
              decorationColor: AppTheme.sage,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Icône Google SVG simplifiée ─────────────────────────────────────────────

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lettres G en couleur Google — sans dépendance externe
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // Cercle de fond
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r, bgPaint);

    // Lettre "G" stylisée avec les couleurs Google
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'G',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
