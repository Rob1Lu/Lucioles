import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../feedback/feedback_bottom_sheet.dart';

class AideScreen extends StatelessWidget {
  const AideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(l10n.aideTitle),
        backgroundColor: AppTheme.creme,
        scrolledUnderElevation: 1,
        shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // ── Bloc feedback ──────────────────────────────────────────────────
          _FeedbackCard(l10n: l10n),

          // ── Tutoriels ──────────────────────────────────────────────────────
          _TitreSectionAide(titre: l10n.aideTutorielsSection),
          _AideExpandable(
            icon: Icons.edit_outlined,
            question: l10n.aideTuto1Q,
            reponse: l10n.aideTuto1R,
          ),
          _AideExpandable(
            icon: Icons.place_outlined,
            question: l10n.aideTuto2Q,
            reponse: l10n.aideTuto2R,
          ),
          _AideExpandable(
            icon: Icons.map_outlined,
            question: l10n.aideTuto3Q,
            reponse: l10n.aideTuto3R,
          ),
          _AideExpandable(
            icon: Icons.filter_list_rounded,
            question: l10n.aideTuto4Q,
            reponse: l10n.aideTuto4R,
          ),

          // ── FAQ ────────────────────────────────────────────────────────────
          _TitreSectionAide(titre: l10n.aideFAQSection),
          _AideExpandable(
            icon: Icons.delete_outline_rounded,
            question: l10n.aideFaq1Q,
            reponse: l10n.aideFaq1R,
          ),
          _AideExpandable(
            icon: Icons.lock_outline_rounded,
            question: l10n.aideFaq2Q,
            reponse: l10n.aideFaq2R,
          ),
          _AideExpandable(
            icon: Icons.person_outline_rounded,
            question: l10n.aideFaq3Q,
            reponse: l10n.aideFaq3R,
          ),
          _AideExpandable(
            icon: Icons.verified_user_outlined,
            question: l10n.aideFaq4Q,
            reponse: l10n.aideFaq4R,
          ),
        ],
      ),
    );
  }
}

// ─── Bloc feedback ────────────────────────────────────────────────────────────

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sage.withValues(alpha: 0.12),
            AppTheme.lucioleOr.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: () => FeedbackBottomSheet.show(context),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.sage.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 20,
                  color: AppTheme.sage,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aideFeedbackTitre,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textePrincipal,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.aideFeedbackSousTitre,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.texteSecondaire,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.sage.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Item extensible ──────────────────────────────────────────────────────────

class _AideExpandable extends StatefulWidget {
  const _AideExpandable({
    required this.icon,
    required this.question,
    required this.reponse,
  });

  final IconData icon;
  final String question;
  final String reponse;

  @override
  State<_AideExpandable> createState() => _AideExpandableState();
}

class _AideExpandableState extends State<_AideExpandable>
    with SingleTickerProviderStateMixin {
  bool _ouvert = false;
  late final AnimationController _ctrl;
  late final Animation<double> _expand;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _expand = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _rotate = Tween<double>(begin: 0, end: 0.5).animate(_expand);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _ouvert = !_ouvert);
    _ouvert ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Icon(widget.icon, size: 18, color: AppTheme.texteSecondaire),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textePrincipal,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RotationTransition(
                    turns: _rotate,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: AppTheme.texteTertaire,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _expand,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(44, 0, 14, 14),
                child: Text(
                  widget.reponse,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.texteSecondaire,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Titre de section ─────────────────────────────────────────────────────────

class _TitreSectionAide extends StatelessWidget {
  const _TitreSectionAide({required this.titre});

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
