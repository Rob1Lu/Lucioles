import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Thème central de l'application Lucioles.
/// Palette douce inspirée du soir d'été : crème, vert sauge, terracotta, or.
class AppTheme {
  AppTheme._();

  // ─── Palette de couleurs ───────────────────────────────────────────────────
  static const Color creme = Color(0xFFF5F0E8);
  static const Color cremeFonce = Color(0xFFEDE6D6);
  static const Color cremeTres = Color(0xFFE4DDD0);

  static const Color sage = Color(0xFF7C9A84);
  static const Color sageClair = Color(0xFFA8C0AC);
  static const Color sagePale = Color(0xFFD4E4D7);

  static const Color terracotta = Color(0xFFC4714E);
  static const Color terracottaClair = Color(0xFFD4937A);

  static const Color textePrincipal = Color(0xFF2C2418);
  static const Color texteSecondaire = Color(0xFF6B5B47);
  static const Color texteTertaire = Color(0xFF9E8E7A);

  /// Fond sombre de la carte nocturne — noir cassé brun-charbon
  static const Color nuitProfonde = Color(0xFF1C1814);

  /// Overlays flottants sur fond sombre (header carte, bottom sheet nuit)
  static const Color nuitSurface = Color(0xFF2A2420);

  /// Couleur dorée des lucioles — le cœur visuel de l'app
  static const Color lucioleOr = Color(0xFFE8C86A);

  /// Halo translucide autour de chaque luciole
  static const Color lucioleHalo = Color(0x55E8C86A);

  // ─── Thème Material ───────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: sage,
          onPrimary: Colors.white,
          primaryContainer: sagePale,
          onPrimaryContainer: textePrincipal,
          secondary: terracotta,
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFF0D5C4),
          onSecondaryContainer: textePrincipal,
          surface: creme,
          onSurface: textePrincipal,
          surfaceContainerHighest: cremeFonce,
          outline: sageClair,
          outlineVariant: cremeTres,
          error: Colors.red.shade400,
          onError: Colors.white,
          errorContainer: Colors.red.shade50,
          onErrorContainer: Colors.red.shade900,
        ),
        scaffoldBackgroundColor: creme,
        // Texte : Playfair Display (serif) pour le contenu, Inter pour l'UI
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textePrincipal,
            height: 1.3,
          ),
          headlineMedium: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textePrincipal,
            height: 1.3,
          ),
          headlineSmall: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textePrincipal,
            height: 1.4,
          ),
          // Corps des notes : serif élégant
          bodyLarge: GoogleFonts.playfairDisplay(
            fontSize: 17,
            color: textePrincipal,
            height: 1.7,
          ),
          // Corps UI
          bodyMedium: GoogleFonts.inter(
            fontSize: 15,
            color: textePrincipal,
            height: 1.5,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 13,
            color: texteSecondaire,
            height: 1.4,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textePrincipal,
          ),
          labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: texteSecondaire,
            letterSpacing: 0.5,
          ),
          labelSmall: GoogleFonts.inter(
            fontSize: 11,
            color: texteTertaire,
            letterSpacing: 0.3,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: creme,
          foregroundColor: textePrincipal,
          elevation: 0,
          scrolledUnderElevation: 1,
          shadowColor: sageClair.withValues(alpha: 0.3),
          centerTitle: true,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textePrincipal,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.7),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: sageClair),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: sageClair),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: sage, width: 2),
          ),
          hintStyle: GoogleFonts.playfairDisplay(
            fontSize: 16,
            color: texteTertaire,
            fontStyle: FontStyle.italic,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: sage,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: sage,
            side: const BorderSide(color: sage),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: creme,
          indicatorColor: sagePale,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: sage);
            }
            return GoogleFonts.inter(fontSize: 11, color: texteSecondaire);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: sage);
            }
            return const IconThemeData(color: texteTertaire);
          }),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: cremeFonce,
          selectedColor: sagePale,
          labelStyle: GoogleFonts.inter(fontSize: 13),
          side: const BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        dividerTheme: const DividerThemeData(
          color: cremeTres,
          thickness: 1,
          space: 0,
        ),
      );
}
