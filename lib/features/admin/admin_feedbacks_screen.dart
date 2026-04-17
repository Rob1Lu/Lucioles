import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/admin_feedback.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';

class AdminFeedbacksScreen extends StatefulWidget {
  const AdminFeedbacksScreen({super.key});

  @override
  State<AdminFeedbacksScreen> createState() => _AdminFeedbacksScreenState();
}

class _AdminFeedbacksScreenState extends State<AdminFeedbacksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().chargerFeedbacks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<AdminProvider>(
      builder: (context, admin, _) {
        return Scaffold(
          backgroundColor: AppTheme.creme,
          appBar: AppBar(
            title: Text(l10n.adminFeedbacksTitle),
            backgroundColor: AppTheme.creme,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
          ),
          body: _buildBody(admin, l10n),
        );
      },
    );
  }

  Widget _buildBody(AdminProvider admin, AppLocalizations l10n) {
    if (admin.chargementFeedbacks) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.sage),
      );
    }

    if (admin.erreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            admin.erreur!,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final items = admin.feedbacks;
    if (items.isEmpty) {
      return Center(
        child: Text(
          l10n.adminFeedbacksVide,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            color: AppTheme.texteSecondaire,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _FeedbackCard(item: items[index]),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.item});
  final AdminFeedback item;

  Color get _typeColor {
    switch (item.type) {
      case 'bug':
        return const Color(0xFFE53E3E);
      case 'suggestion':
        return const Color(0xFF3182CE);
      default:
        return AppTheme.texteSecondaire;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('d MMM yyyy · HH:mm', 'fr').format(item.createdAt.toLocal());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: user + date
          Row(
            children: [
              Expanded(
                child: Text(
                  item.displayName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.texteSecondaire,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppTheme.texteTertaire,
                ),
              ),
            ],
          ),
          if (item.type != null) ...[
            const SizedBox(height: 8),
            _TypeBadge(type: item.type!, color: _typeColor),
          ],
          const SizedBox(height: 8),
          Text(
            item.message,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textePrincipal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type, required this.color});
  final String type;
  final Color color;

  String _label(String t) {
    switch (t) {
      case 'bug':
        return 'Bug';
      case 'suggestion':
        return 'Suggestion';
      default:
        return 'Autre';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        _label(type),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
