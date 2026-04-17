import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _page = 0;

  late final AnimationController _floatCtrl;
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  static const _totalPages = 3;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _terminer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    widget.onDone();
  }

  Future<void> _allerPage(int target) async {
    await _fadeCtrl.reverse();
    setState(() => _page = target);
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    await _fadeCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _totalPages,
            itemBuilder: (context, index) => _OnboardingPage(
              data: _pages(l10n)[index],
              floatAnim: _floatCtrl,
              fadeAnim: _fadeAnim,
              screenSize: size,
            ),
          ),

          // Bouton Passer — top right
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            right: 20,
            child: TextButton(
              onPressed: _terminer,
              child: Text(
                l10n.onboardingPasser,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.texteSecondaire,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bas : dots + bouton
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.paddingOf(context).bottom + 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dots(current: _page, total: _totalPages),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: _page < _totalPages - 1
                      ? _BoutonSuivant(
                          label: l10n.onboardingSuivant,
                          onTap: () => _allerPage(_page + 1),
                        )
                      : _BoutonCommencer(
                          label: l10n.onboardingCommencer,
                          onTap: _terminer,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_PageData> _pages(AppLocalizations l10n) => [
        _PageData(
          accentColor: AppTheme.lucioleOr,
          icon: null,
          titre: l10n.onboarding1Titre,
          corps: l10n.onboarding1Corps,
          decorations: const [
            _Deco(dx: 0.15, dy: 0.18, size: 6, opacity: 0.6, phaseOffset: 0.0),
            _Deco(dx: 0.80, dy: 0.12, size: 4, opacity: 0.4, phaseOffset: 0.4),
            _Deco(dx: 0.72, dy: 0.38, size: 8, opacity: 0.5, phaseOffset: 0.7),
            _Deco(dx: 0.22, dy: 0.42, size: 5, opacity: 0.35, phaseOffset: 0.2),
            _Deco(dx: 0.50, dy: 0.08, size: 3, opacity: 0.5, phaseOffset: 0.9),
          ],
        ),
        _PageData(
          accentColor: AppTheme.sage,
          icon: Icons.place_outlined,
          titre: l10n.onboarding2Titre,
          corps: l10n.onboarding2Corps,
          decorations: const [
            _Deco(dx: 0.12, dy: 0.10, size: 5, opacity: 0.4, phaseOffset: 0.3),
            _Deco(dx: 0.85, dy: 0.20, size: 7, opacity: 0.5, phaseOffset: 0.6),
            _Deco(dx: 0.68, dy: 0.40, size: 4, opacity: 0.35, phaseOffset: 0.1),
            _Deco(dx: 0.28, dy: 0.35, size: 6, opacity: 0.4, phaseOffset: 0.8),
          ],
        ),
        _PageData(
          accentColor: AppTheme.terracotta,
          icon: Icons.verified_user_outlined,
          titre: l10n.onboarding3Titre,
          corps: l10n.onboarding3Corps,
          decorations: const [
            _Deco(dx: 0.20, dy: 0.15, size: 6, opacity: 0.45, phaseOffset: 0.5),
            _Deco(dx: 0.78, dy: 0.10, size: 4, opacity: 0.35, phaseOffset: 0.2),
            _Deco(dx: 0.65, dy: 0.38, size: 7, opacity: 0.4, phaseOffset: 0.7),
            _Deco(dx: 0.30, dy: 0.42, size: 5, opacity: 0.3, phaseOffset: 0.0),
            _Deco(dx: 0.50, dy: 0.05, size: 3, opacity: 0.5, phaseOffset: 0.9),
          ],
        ),
      ];
}

// ─── Data ─────────────────────────────────────────────────────────────────────

class _PageData {
  const _PageData({
    required this.accentColor,
    required this.icon,
    required this.titre,
    required this.corps,
    required this.decorations,
  });

  final Color accentColor;
  final IconData? icon;
  final String titre;
  final String corps;
  final List<_Deco> decorations;
}

class _Deco {
  const _Deco({
    required this.dx,
    required this.dy,
    required this.size,
    required this.opacity,
    required this.phaseOffset,
  });

  final double dx;
  final double dy;
  final double size;
  final double opacity;
  final double phaseOffset;
}

// ─── Page ─────────────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.floatAnim,
    required this.fadeAnim,
    required this.screenSize,
  });

  final _PageData data;
  final Animation<double> floatAnim;
  final Animation<double> fadeAnim;
  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnim,
      child: Column(
        children: [
          // Illustration — moitié haute
          Expanded(
            flex: 5,
            child: _Illustration(data: data, floatAnim: floatAnim),
          ),
          // Texte — moitié basse
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.titre,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textePrincipal,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data.corps,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppTheme.texteSecondaire,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Illustration ─────────────────────────────────────────────────────────────

class _Illustration extends StatelessWidget {
  const _Illustration({required this.data, required this.floatAnim});

  final _PageData data;
  final Animation<double> floatAnim;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Cercle de fond
            Center(
              child: AnimatedBuilder(
                animation: floatAnim,
                builder: (context, child) {
                  final dy = (floatAnim.value - 0.5) * 12;
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        data.accentColor.withValues(alpha: 0.18),
                        data.accentColor.withValues(alpha: 0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Icône centrale
            Center(
              child: AnimatedBuilder(
                animation: floatAnim,
                builder: (context, child) {
                  final dy = (floatAnim.value - 0.5) * 14;
                  return Transform.translate(
                    offset: Offset(0, dy),
                    child: child,
                  );
                },
                child: data.icon == null
                    ? SvgPicture.asset(
                        'lib/assets/icons/lucioles_icon.svg',
                        width: 120,
                        height: 120,
                      )
                    : Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: data.accentColor.withValues(alpha: 0.12),
                          border: Border.all(
                            color: data.accentColor.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          data.icon,
                          size: 44,
                          color: data.accentColor,
                        ),
                      ),
              ),
            ),

            // Points décoratifs flottants
            ...data.decorations.map((deco) {
              return AnimatedBuilder(
                animation: floatAnim,
                builder: (context, _) {
                  final phase = (floatAnim.value + deco.phaseOffset) % 1.0;
                  final dy = math.sin(phase * math.pi * 2) * 8;
                  return Positioned(
                    left: deco.dx * w - deco.size / 2,
                    top: deco.dy * h + dy - deco.size / 2,
                    child: Container(
                      width: deco.size,
                      height: deco.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.accentColor
                            .withValues(alpha: deco.opacity),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        );
      },
    );
  }
}

// ─── Dots de progression ──────────────────────────────────────────────────────

class _Dots extends StatelessWidget {
  const _Dots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.textePrincipal
                : AppTheme.cremeTres,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ─── Boutons ──────────────────────────────────────────────────────────────────

class _BoutonSuivant extends StatelessWidget {
  const _BoutonSuivant({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textePrincipal,
          side: BorderSide(color: AppTheme.cremeTres, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textePrincipal,
          ),
        ),
      ),
    );
  }
}

class _BoutonCommencer extends StatelessWidget {
  const _BoutonCommencer({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.sage,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
