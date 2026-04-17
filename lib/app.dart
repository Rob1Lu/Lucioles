import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'features/carte/carte_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profil/profil_screen.dart';
import 'features/saisie/saisie_screen.dart';
import 'l10n/app_localizations.dart';
import 'shared/providers/locale_provider.dart';

class LuciolesApp extends StatelessWidget {
  const LuciolesApp({super.key, required this.onboardingDone});

  final bool onboardingDone;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp(
          title: 'Lucioles',
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          // Locale active — pilotée par LocaleProvider
          locale: localeProvider.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // Ferme le clavier quand l'utilisateur tape en dehors d'un champ de saisie
          builder: (context, child) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            behavior: HitTestBehavior.opaque,
            child: child!,
          ),
          home: _HomeGate(onboardingDone: onboardingDone),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _HomeGate extends StatefulWidget {
  const _HomeGate({required this.onboardingDone});

  final bool onboardingDone;

  @override
  State<_HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<_HomeGate> {
  late bool _showApp;

  @override
  void initState() {
    super.initState();
    _showApp = widget.onboardingDone;
  }

  void _terminerOnboarding() {
    setState(() => _showApp = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeIn,
      child: _showApp
          ? const _MainNavigation()
          : OnboardingScreen(
              key: const ValueKey('onboarding'),
              onDone: _terminerOnboarding,
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _MainNavigation extends StatefulWidget {
  const _MainNavigation();

  @override
  State<_MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<_MainNavigation>
    with SingleTickerProviderStateMixin {
  int _indexActuel = 0;

  late final AnimationController _themeCtrl;
  late final Animation<double> _themeFade;

  static const int _indexNuit = 1;

  static const List<Widget> _ecrans = [
    SaisieScreen(),
    CarteScreen(),
    ProfilScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _themeCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _themeFade = CurvedAnimation(parent: _themeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _themeCtrl.dispose();
    super.dispose();
  }

  void _changerOnglet(int index) {
    setState(() => _indexActuel = index);
    if (index == _indexNuit) {
      _themeCtrl.forward();
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      );
    } else {
      _themeCtrl.reverse();
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppTheme.creme,
      body: _buildBody(),
      bottomNavigationBar: _buildNavBar(l10n),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: List.generate(_ecrans.length, (i) {
        final isActive = _indexActuel == i;
        return AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          child: IgnorePointer(
            ignoring: !isActive,
            child: TickerMode(enabled: isActive, child: _ecrans[i]),
          ),
        );
      }),
    );
  }

  Widget _buildNavBar(AppLocalizations l10n) {
    return AnimatedBuilder(
      animation: _themeFade,
      builder: (context, child) {
        final t = _themeFade.value;
        final bgColor = Color.lerp(AppTheme.creme, AppTheme.nuitProfonde, t)!;
        final borderColor = Color.lerp(
          AppTheme.cremeTres, Colors.white.withValues(alpha: 0.06), t)!;
        final selectedColor = Color.lerp(AppTheme.sage, AppTheme.lucioleOr, t)!;
        final unselectedColor = Color.lerp(
          AppTheme.texteTertaire,
          AppTheme.cremeFonce.withValues(alpha: 0.40),
          t,
        )!;
        final indicatorColor = Color.lerp(
          AppTheme.sagePale,
          AppTheme.lucioleOr.withValues(alpha: 0.18),
          t,
        )!;

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(top: BorderSide(color: borderColor, width: 1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05 + t * 0.20),
                blurRadius: 14,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                indicatorColor: indicatorColor,
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  final sel = states.contains(WidgetState.selected);
                  return GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? selectedColor : unselectedColor,
                  );
                }),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  final sel = states.contains(WidgetState.selected);
                  return IconThemeData(
                    color: sel ? selectedColor : unselectedColor,
                  );
                }),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              selectedIndex: _indexActuel,
              onDestinationSelected: _changerOnglet,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.edit_outlined),
                  selectedIcon: const Icon(Icons.edit),
                  label: l10n.navSaisie,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.map_outlined),
                  selectedIcon: const Icon(Icons.map),
                  label: l10n.navCarte,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: l10n.navMoi,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
