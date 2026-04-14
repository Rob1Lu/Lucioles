import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme.dart';

/// Construit une [SnackBar] au style Lucioles uniforme.
///
/// Affiche une étoile dorée ✦ suivie de [message] en Playfair Display italique.
SnackBar buildStyledSnackBar(
  String message, {
  Duration duration = const Duration(seconds: 3),
}) {
  return SnackBar(
    content: Row(
      children: [
        const Text('✦', style: TextStyle(color: AppTheme.lucioleOr, fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: GoogleFonts.playfairDisplay(
              fontSize: 15,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: AppTheme.textePrincipal,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: duration,
  );
}
