import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants.dart';
import '../../../core/theme.dart';
import '../../../data/models/entree.dart';

/// Carte représentant une entrée dans le fil du temps.
///
/// Affiche la date, le texte, le lieu et une miniature photo.
/// Design calme, sans action, contemplatif.
class EntreeCardWidget extends StatelessWidget {
  const EntreeCardWidget({
    super.key,
    required this.entree,
    this.onSupprimerDemande,
  });

  final Entree entree;

  /// Callback appelé quand l'utilisateur demande à supprimer l'entrée
  final VoidCallback? onSupprimerDemande;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("d MMMM yyyy", "fr_FR");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cremeTres, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── En-tête : luciole + date + badge saison ───────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _LucioleMini(),
                const SizedBox(width: 10),
                Text(
                  dateFormat.format(entree.dateCreation),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.texteSecondaire,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Badge saison
                _BadgeSaison(saison: entree.saison),
              ],
            ),
            const SizedBox(height: 14),

            // ── Texte de l'entrée ─────────────────────────────────────────
            Text(
              entree.texte,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                color: AppTheme.textePrincipal,
                height: 1.65,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),

            // ── Photo miniature ───────────────────────────────────────────
            if (entree.photoUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  entree.photoUrl!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            ],

            // ── Pied de carte : lieu + bouton supprimer ───────────────────
            if (entree.aLieu || onSupprimerDemande != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (entree.aLieu) ...[
                    const Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: AppTheme.terracotta,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        entree.lieuAffichage,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.terracotta,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ] else
                    const Spacer(),
                  if (onSupprimerDemande != null)
                    GestureDetector(
                      onTap: onSupprimerDemande,
                      child: Text(
                        'Supprimer',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.texteTertaire,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.texteTertaire,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Petite luciole décorative dans le coin de chaque carte
class _LucioleMini extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.lucioleOr,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lucioleHalo,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

/// Badge coloré indiquant la saison de l'entrée
class _BadgeSaison extends StatelessWidget {
  const _BadgeSaison({required this.saison});

  final Saison saison;

  // Couleur associée à chaque saison
  Color get _couleur {
    switch (saison) {
      case Saison.printemps:
        return const Color(0xFFB8D4A8); // vert tendre
      case Saison.ete:
        return const Color(0xFFE8C86A); // or chaud
      case Saison.automne:
        return const Color(0xFFC4714E); // terracotta
      case Saison.hiver:
        return const Color(0xFF9DB5C4); // bleu givré
      case Saison.toutes:
        return AppTheme.sageClair;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _couleur.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _couleur.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        saison.label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: _couleur.withValues(alpha: 1.0),
        ),
      ),
    );
  }
}
