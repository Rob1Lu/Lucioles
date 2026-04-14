import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/entree.dart';
import '../../shared/providers/entrees_provider.dart';
import 'widgets/entree_card_widget.dart';

/// Écran du fil du temps — liste chronologique des entrées passées.
///
/// Propose un filtre par saison pour retrouver les souvenirs de l'année.
/// Ton contemplatif : aucune action intrusive, aucun badge, aucun streak.
class FilScreen extends StatelessWidget {
  const FilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EntreesProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppTheme.creme,
          appBar: AppBar(
            title: const Text('Fil du temps'),
            bottom: _buildFiltresSaison(context, provider),
          ),
          body: _buildCorps(context, provider),
        );
      },
    );
  }

  /// Barre de filtre par saison sous l'AppBar.
  PreferredSizeWidget _buildFiltresSaison(
    BuildContext context,
    EntreesProvider provider,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(52),
      child: Container(
        height: 52,
        padding: const EdgeInsets.only(left: 16, bottom: 10),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: Saison.values.map((saison) {
            final selected = provider.filtreSaison == saison;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(saison.label),
                selected: selected,
                onSelected: (_) => provider.setFiltreSaison(saison),
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
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCorps(BuildContext context, EntreesProvider provider) {
    // Chargement en cours
    if (provider.chargement) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.sage),
      );
    }

    final entrees = provider.entreesFiltrees;

    // État vide — premier lancement ou filtre sans résultat
    if (entrees.isEmpty) {
      return _buildEtatVide(context, provider.filtreSaison);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      itemCount: entrees.length,
      itemBuilder: (context, index) {
        final entree = entrees[index];

        // Affiche un séparateur d'année quand elle change
        final showAnnee = index == 0 ||
            entrees[index - 1].dateCreation.year != entree.dateCreation.year;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showAnnee) _buildSeparateurAnnee(entree.dateCreation.year),
            EntreeCardWidget(
              entree: entree,
              onSupprimerDemande: () =>
                  _confirmerSuppression(context, provider, entree),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSeparateurAnnee(int annee) {
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
          const Expanded(
            child: Divider(height: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildEtatVide(BuildContext context, Saison filtre) {
    final estFiltre = filtre != Saison.toutes;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '✦',
              style: TextStyle(fontSize: 32, color: AppTheme.lucioleOr),
            ),
            const SizedBox(height: 20),
            Text(
              estFiltre
                  ? 'Aucune luciole\ncet ${filtre.label.toLowerCase()}.'
                  : 'Ton atlas est encore vide.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: AppTheme.textePrincipal,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              estFiltre
                  ? 'Change de saison pour explorer d\'autres souvenirs.'
                  : 'Commence par noter ce qui t\'a touché cette semaine.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.texteSecondaire,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Dialogue de confirmation avant suppression d'une entrée.
  void _confirmerSuppression(
    BuildContext context,
    EntreesProvider provider,
    Entree entree,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Supprimer cette luciole ?',
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          'Cette action est irréversible. Ton souvenir sera\ndéfinitivement effacé.',
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
              'Annuler',
              style: GoogleFonts.inter(color: AppTheme.texteSecondaire),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.supprimer(entree.id);
            },
            child: Text(
              'Supprimer',
              style: GoogleFonts.inter(color: Colors.red.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
