import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/admin_signalement_archive.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';

class AdminSignalementsArchivesScreen extends StatefulWidget {
  const AdminSignalementsArchivesScreen({super.key});

  @override
  State<AdminSignalementsArchivesScreen> createState() =>
      _AdminSignalementsArchivesScreenState();
}

class _AdminSignalementsArchivesScreenState
    extends State<AdminSignalementsArchivesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.trim().toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    await context.read<AdminProvider>().chargerSignalementsArchives();
    if (mounted) setState(() => _chargement = false);
  }

  List<AdminSignalementArchive> _filtrer(
      List<AdminSignalementArchive> items) {
    if (_query.isEmpty) return items;
    return items.where((item) {
      return (item.userEmail?.toLowerCase().contains(_query) ?? false) ||
          (item.username?.toLowerCase().contains(_query) ?? false) ||
          item.texte.toLowerCase().contains(_query) ||
          _formatDate(item.dateCreation).contains(_query) ||
          _formatDate(item.adminReviewedAt).contains(_query);
    }).toList();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final archives = context.watch<AdminProvider>().signalementsArchives;
    final filtered = _filtrer(archives);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(
          _chargement || archives.isEmpty
              ? l10n.adminArchivesTitle
              : '${l10n.adminArchivesTitle} (${archives.length})',
        ),
        backgroundColor: AppTheme.creme,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          _SearchBar(controller: _searchCtrl, hint: l10n.adminArchivesRecherche),
          Expanded(child: _buildBody(filtered, l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(List<AdminSignalementArchive> items, AppLocalizations l10n) {
    if (_chargement) {
      return const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.sage),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 52,
                color: AppTheme.sage.withValues(alpha: 0.45),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.adminArchivesVide,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 17,
                  color: AppTheme.texteSecondaire,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: items.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) => _ArchiveCard(
        item: items[i],
        l10n: l10n,
        formatDate: _formatDate,
      ),
    );
  }
}

// ─── Barre de recherche ───────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.hint});

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textePrincipal),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.texteTertaire,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppTheme.texteTertaire,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (ctx, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.close_rounded,
                        size: 18, color: AppTheme.texteTertaire),
                    onPressed: controller.clear,
                  ),
          ),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.7),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.cremeTres),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.cremeTres),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: AppTheme.sage.withValues(alpha: 0.5), width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── Carte archive ────────────────────────────────────────────────────────────

class _ArchiveCard extends StatelessWidget {
  const _ArchiveCard({
    required this.item,
    required this.l10n,
    required this.formatDate,
  });

  final AdminSignalementArchive item;
  final AppLocalizations l10n;
  final String Function(DateTime) formatDate;

  Color get _outcomeColor =>
      item.isRestricted ? Colors.red.shade400 : AppTheme.sage;

  IconData get _outcomeIcon =>
      item.isRestricted ? Icons.block_rounded : Icons.check_circle_rounded;

  String _outcomeLabel(AppLocalizations l10n) =>
      item.isRestricted ? l10n.adminArchivesRestreint : l10n.adminArchivesApprouve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Icône résultat ────────────────────────────────────────
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _outcomeColor.withValues(alpha: 0.12),
              ),
              child: Icon(_outcomeIcon, size: 18, color: _outcomeColor),
            ),
            const SizedBox(width: 12),

            // ── Contenu ───────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + badge résultat
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.displayName,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.userDeleted
                                ? AppTheme.texteTertaire
                                : AppTheme.textePrincipal,
                            fontStyle: item.userDeleted
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _OutcomeBadge(
                        label: _outcomeLabel(l10n),
                        color: _outcomeColor,
                      ),
                    ],
                  ),

                  // Email si différent du displayName
                  if (item.userEmail != null && item.username != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      item.userEmail!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.texteTertaire,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Extrait du texte
                  Text(
                    item.texte,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppTheme.texteSecondaire,
                      height: 1.45,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Dates + signalements
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        label: l10n.adminArchivesPublieLe(
                            formatDate(item.dateCreation)),
                      ),
                      _MetaChip(
                        icon: Icons.gavel_rounded,
                        label: l10n.adminArchivesDecisionLe(
                            formatDate(item.adminReviewedAt)),
                      ),
                      _MetaChip(
                        icon: Icons.flag_outlined,
                        label: '${item.signalementCount}',
                        color: item.signalementCount >= 3
                            ? Colors.red.shade400
                            : AppTheme.texteTertaire,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sous-widgets ─────────────────────────────────────────────────────────────

class _OutcomeBadge extends StatelessWidget {
  const _OutcomeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.7,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.texteTertaire;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: c),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: c),
        ),
      ],
    );
  }
}
