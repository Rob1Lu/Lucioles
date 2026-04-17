import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../data/supabase_feedback_datasource.dart';
import '../../l10n/app_localizations.dart';

class FeedbackBottomSheet extends StatefulWidget {
  const FeedbackBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackBottomSheet(),
    );
  }

  @override
  State<FeedbackBottomSheet> createState() => _FeedbackBottomSheetState();
}

class _FeedbackBottomSheetState extends State<FeedbackBottomSheet> {
  final _controller = TextEditingController();
  final _datasource = SupabaseFeedbackDatasource();

  String? _type;
  bool _chargement = false;
  bool _succes = false;
  String? _erreur;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _envoyer(AppLocalizations l10n) async {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      setState(() => _erreur = l10n.feedbackMessageVide);
      return;
    }
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      await _datasource.envoyerFeedback(message: message, type: _type);
      if (!mounted) return;
      setState(() {
        _chargement = false;
        _succes = true;
      });
      // Capture la route AVANT le gap asynchrone pour éviter
      // que le pop auto s'exécute sur une route déjà fermée par
      // l'utilisateur (tap extérieur) → écran noir.
      final route = ModalRoute.of(context);
      await Future.delayed(const Duration(milliseconds: 1600));
      if (!mounted || route?.isActive != true) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _chargement = false;
        _erreur = l10n.feedbackErreur;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.creme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppTheme.cremeTres,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Contenu selon état
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _succes ? _buildSucces(l10n) : _buildFormulaire(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildSucces(AppLocalizations l10n) {
    return Padding(
      key: const ValueKey('succes'),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 52,
              color: AppTheme.sage.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.feedbackConfirmation,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                color: AppTheme.textePrincipal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaire(AppLocalizations l10n) {
    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Text(
          l10n.feedbackTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        const SizedBox(height: 16),

        // Chips de type (optionnel)
        Wrap(
          spacing: 8,
          children: [
            _TypeChip(
              label: l10n.feedbackTypeBug,
              icon: Icons.bug_report_outlined,
              value: 'bug',
              selected: _type == 'bug',
              onTap: () => setState(
                  () => _type = _type == 'bug' ? null : 'bug'),
            ),
            _TypeChip(
              label: l10n.feedbackTypeSuggestion,
              icon: Icons.lightbulb_outline_rounded,
              value: 'suggestion',
              selected: _type == 'suggestion',
              onTap: () => setState(
                  () => _type = _type == 'suggestion' ? null : 'suggestion'),
            ),
            _TypeChip(
              label: l10n.feedbackTypeAutre,
              icon: Icons.chat_bubble_outline_rounded,
              value: 'autre',
              selected: _type == 'autre',
              onTap: () => setState(
                  () => _type = _type == 'autre' ? null : 'autre'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Champ message
        TextField(
          controller: _controller,
          maxLines: 4,
          maxLength: 500,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textePrincipal,
          ),
          decoration: InputDecoration(
            hintText: l10n.feedbackMessageHint,
            hintStyle: GoogleFonts.playfairDisplay(
              fontSize: 14,
              color: AppTheme.texteTertaire,
              fontStyle: FontStyle.italic,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.7),
            counterStyle: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.texteTertaire,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.cremeTres),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppTheme.cremeTres),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppTheme.sage, width: 1.5),
            ),
            errorText: _erreur,
          ),
          onChanged: (_) {
            if (_erreur != null) setState(() => _erreur = null);
          },
        ),
        const SizedBox(height: 16),

        // Bouton envoyer
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _chargement ? null : () => _envoyer(l10n),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.sage,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: _chargement
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.feedbackEnvoyer),
          ),
        ),
      ],
    );
  }
}

// ─── Chip de type ─────────────────────────────────────────────────────────────

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.sage.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.sage : AppTheme.cremeTres,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected ? AppTheme.sage : AppTheme.texteSecondaire,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppTheme.sage : AppTheme.texteSecondaire,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
