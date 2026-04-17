import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/admin_user.dart';
import '../../data/models/signalement_item.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';
import 'admin_user_detail_screen.dart';

class AdminSignalementsScreen extends StatefulWidget {
  const AdminSignalementsScreen({super.key});

  @override
  State<AdminSignalementsScreen> createState() =>
      _AdminSignalementsScreenState();
}

class _AdminSignalementsScreenState extends State<AdminSignalementsScreen> {
  late PageController _pageController;
  List<SignalementItem> _items = [];
  final Set<String> _dismissing = {};
  bool _chargement = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _charger());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _charger() async {
    final admin = context.read<AdminProvider>();
    await admin.chargerSignalements();
    if (!mounted) return;
    setState(() {
      _items = List.from(admin.signalements);
      _chargement = false;
    });
  }

  Future<void> _agir(SignalementItem item, String action) async {
    if (_dismissing.contains(item.entreeId)) return;
    setState(() => _dismissing.add(item.entreeId));
    // Fire server call without awaiting — UI should feel instant
    context.read<AdminProvider>().reviewerEntree(item.entreeId, action);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() {
      _dismissing.remove(item.entreeId);
      final idx = _items.indexWhere((e) => e.entreeId == item.entreeId);
      if (idx != -1) {
        final wasLast = idx >= _items.length - 1;
        _items.removeAt(idx);
        if (wasLast && _items.isNotEmpty) {
          _pageController.jumpToPage(_items.length - 1);
        }
      }
    });
  }

  void _voirProfil(BuildContext context, SignalementItem item) {
    if (item.userId == null) return;
    final admin = context.read<AdminProvider>();
    final user = AdminUser(
      id: item.userId!,
      email: item.userEmail ?? '',
      username: item.username,
      avatarUrl: item.avatarUrl,
      createdAt: item.dateCreation,
      isAdmin: false,
      lucioleCount: 0,
    );
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider.value(
        value: admin,
        child: AdminUserDetailScreen(user: user),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.creme,
      appBar: AppBar(
        title: Text(
          (!_chargement && _items.isNotEmpty)
              ? '${l10n.adminSignalementsTitle} (${_items.length})'
              : l10n.adminSignalementsTitle,
        ),
        backgroundColor: AppTheme.creme,
        scrolledUnderElevation: 0,
      ),
      body: _chargement
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.sage,
              ),
            )
          : _items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 56,
                          color: AppTheme.sage.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.adminSignalementsVide,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            color: AppTheme.texteSecondaire,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return AnimatedOpacity(
                      opacity: _dismissing.contains(item.entreeId) ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 280),
                      child: _SignalementCard(
                        item: item,
                        onApprouver: () => _agir(item, 'approved'),
                        onRestreindre: () => _agir(item, 'restricted'),
                        onVoirProfil: () => _voirProfil(context, item),
                        l10n: l10n,
                      ),
                    );
                  },
                ),
    );
  }
}

// ─── Card ─────────────────────────────────────────────────────────────────────

class _SignalementCard extends StatelessWidget {
  const _SignalementCard({
    required this.item,
    required this.onApprouver,
    required this.onRestreindre,
    required this.onVoirProfil,
    required this.l10n,
  });

  final SignalementItem item;
  final VoidCallback onApprouver;
  final VoidCallback onRestreindre;
  final VoidCallback onVoirProfil;
  final AppLocalizations l10n;

  Color get _borderColor {
    if (item.userReportedCount >= 10) return Colors.purple.shade300;
    if (item.signalementCount >= 3) return Colors.red.shade300;
    return AppTheme.cremeTres;
  }

  double get _borderWidth {
    if (item.userReportedCount >= 10 || item.signalementCount >= 3) return 2.5;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _borderColor, width: _borderWidth),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withValues(alpha: 0.12),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            _UserHeader(item: item, onTap: onVoirProfil, l10n: l10n),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.texte,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        color: AppTheme.textePrincipal,
                        height: 1.7,
                      ),
                    ),
                    if (item.photoUrl != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          item.photoUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, e, s) => Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppTheme.cremeFonce,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.broken_image_outlined,
                              color: AppTheme.texteTertaire,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            _StatsRow(item: item, l10n: l10n),
            _ActionButtons(
              onApprouver: onApprouver,
              onRestreindre: onRestreindre,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── User header ──────────────────────────────────────────────────────────────

class _UserHeader extends StatelessWidget {
  const _UserHeader({
    required this.item,
    required this.onTap,
    required this.l10n,
  });

  final SignalementItem item;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final deleted = item.userDeleted || item.userId == null;
    return InkWell(
      onTap: deleted ? null : onTap,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Opacity(
          opacity: deleted ? 0.55 : 1.0,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: deleted ? AppTheme.cremeFonce : AppTheme.sagePale,
                  border: Border.all(
                    color: AppTheme.sageClair.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: deleted
                    ? const Icon(
                        Icons.person_off_outlined,
                        size: 22,
                        color: AppTheme.texteTertaire,
                      )
                    : (item.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              item.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, e, s) => const Icon(
                                Icons.person_rounded,
                                size: 22,
                                color: AppTheme.sage,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person_rounded,
                            size: 22,
                            color: AppTheme.sage,
                          )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.displayName,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: deleted
                            ? AppTheme.texteTertaire
                            : AppTheme.textePrincipal,
                        fontStyle: deleted ? FontStyle.italic : FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      deleted
                          ? l10n.adminSignalementsUserSupprimeLabel
                          : l10n.adminSignalementsLuciolesSig(
                              item.userReportedCount),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: item.userReportedCount >= 10 && !deleted
                            ? Colors.purple.shade400
                            : AppTheme.texteSecondaire,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.isRestricted)
                    _Badge(
                      label: l10n.adminSignalementsTagRestreinte,
                      color: Colors.red.shade400,
                    ),
                  if (item.userReportedCount >= 10 && !deleted) ...[
                    if (item.isRestricted) const SizedBox(height: 4),
                    _Badge(
                      label: l10n.adminSignalementsTagRecidiviste,
                      color: Colors.purple.shade400,
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                deleted
                    ? Icons.block_outlined
                    : Icons.chevron_right_rounded,
                size: 18,
                color: AppTheme.texteTertaire,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.item, required this.l10n});

  final SignalementItem item;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final alerte = item.signalementCount >= 3;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 13,
            color: AppTheme.texteTertaire,
          ),
          const SizedBox(width: 5),
          Text(
            _formatDate(item.dateCreation),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.texteTertaire,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.flag_outlined,
            size: 13,
            color: alerte ? Colors.red.shade400 : AppTheme.texteSecondaire,
          ),
          const SizedBox(width: 5),
          Text(
            l10n.adminSignalementsCount(item.signalementCount),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: alerte ? Colors.red.shade400 : AppTheme.texteSecondaire,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

// ─── Action buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onApprouver,
    required this.onRestreindre,
    required this.l10n,
  });

  final VoidCallback onApprouver;
  final VoidCallback onRestreindre;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onRestreindre,
              icon: const Icon(Icons.block_rounded, size: 15),
              label: Text(l10n.adminSignalementsRestreindre),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade400,
                side: BorderSide(color: Colors.red.shade200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onApprouver,
              icon: const Icon(Icons.check_rounded, size: 15),
              label: Text(l10n.adminSignalementsApprouver),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sage,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Badge ────────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
