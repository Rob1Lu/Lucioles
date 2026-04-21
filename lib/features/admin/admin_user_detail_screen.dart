import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/admin_user.dart';
import '../../data/models/entree.dart';
import '../../features/fil/widgets/entree_card_widget.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';

class AdminUserDetailScreen extends StatefulWidget {
  const AdminUserDetailScreen({super.key, required this.user});

  final AdminUser user;

  @override
  State<AdminUserDetailScreen> createState() =>
      _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState extends State<AdminUserDetailScreen> {
  String? _avatarSignedUrl;
  List<Entree>? _entrees;
  bool _chargementEntrees = true;
  late bool _isAdmin;

  @override
  void initState() {
    super.initState();
    _isAdmin = widget.user.isAdmin;
    _charger();
  }

  void _confirmerToggleAdmin(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final grant = !_isAdmin;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          grant ? l10n.adminUsersGrantAdminTitre : l10n.adminUsersRevokeAdminTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          grant
              ? l10n.adminUsersGrantAdminMessage(widget.user.displayName)
              : l10n.adminUsersRevokeAdminMessage(widget.user.displayName),
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.texteSecondaire,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.filSupprimerAnnuler,
                style: GoogleFonts.inter(color: AppTheme.texteSecondaire)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final admin = context.read<AdminProvider>();
              final ok = await admin.toggleAdminRole(widget.user.id, grant: grant);
              if (ok && mounted) setState(() => _isAdmin = grant);
            },
            child: Text(
              l10n.carteDatePickerConfirmer,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: grant ? AppTheme.sage : Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _adminReviewer(Entree entree, String action) async {
    final admin = context.read<AdminProvider>();
    await admin.reviewerEntree(entree.id, action);
    if (!mounted) return;
    setState(() {
      _entrees = _entrees!.map((e) {
        if (e.id == entree.id) {
          return e.copyWith(isRestricted: action == 'restricted');
        }
        return e;
      }).toList();
    });
  }

  void _ouvrirEntreeAdmin(BuildContext context, Entree entree) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AdminEntreeBottomSheet(
        entree: entree,
        l10n: l10n,
        onRestreindre: () async {
          Navigator.of(context).pop();
          await _adminReviewer(entree, 'restricted');
        },
        onApprouver: () async {
          Navigator.of(context).pop();
          await _adminReviewer(entree, 'approved');
        },
      ),
    );
  }

  Future<void> _charger() async {
    final admin = context.read<AdminProvider>();

    final futures = <Future>[
      admin.chargerEntreesUtilisateur(widget.user.id),
    ];
    if (widget.user.avatarUrl != null) {
      futures.add(admin.getAvatarSignedUrl(widget.user.avatarUrl!));
    }

    final results = await Future.wait(futures);

    if (!mounted) return;
    setState(() {
      _entrees = results[0] as List<Entree>;
      if (widget.user.avatarUrl != null && results.length > 1) {
        _avatarSignedUrl = results[1] as String?;
      }
      _chargementEntrees = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = widget.user;
    final entrees = _entrees ?? [];

    return Scaffold(
      backgroundColor: AppTheme.creme,
      body: CustomScrollView(
        slivers: [
          // ── App bar ─────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            title: Text(l10n.adminUserDetailTitle),
            backgroundColor: AppTheme.creme,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
          ),

          // ── Card identité ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _IdentiteCard(
              user: user,
              isAdmin: _isAdmin,
              avatarSignedUrl: _avatarSignedUrl,
            ),
          ),

          // ── Action admin role ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _AdminRoleCard(
              isAdmin: _isAdmin,
              onToggle: () => _confirmerToggleAdmin(context),
            ),
          ),

          // ── Stats ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _StatsCard(user: user, entrees: entrees, l10n: l10n),
          ),

          // ── Fil ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _FilHeader(l10n: l10n),
          ),

          if (_chargementEntrees)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppTheme.sage),
                ),
              ),
            )
          else if (entrees.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 40),
                child: Column(
                  children: [
                    Text('✦',
                        style: TextStyle(
                            fontSize: 28, color: AppTheme.lucioleOr)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.filVide,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 16,
                        color: AppTheme.textePrincipal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList.builder(
              itemCount: entrees.length,
              itemBuilder: (context, index) {
                final entree = entrees[index];
                final showAnnee = index == 0 ||
                    entrees[index - 1].dateCreation.year !=
                        entree.dateCreation.year;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showAnnee)
                      _SeparateurAnnee(annee: entree.dateCreation.year),
                    GestureDetector(
                      onTap: () => _ouvrirEntreeAdmin(context, entree),
                      child: EntreeCardWidget(entree: entree),
                    ),
                  ],
                );
              },
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Card identité ────────────────────────────────────────────────────────────

class _IdentiteCard extends StatelessWidget {
  const _IdentiteCard({
    required this.user,
    required this.isAdmin,
    required this.avatarSignedUrl,
  });

  final AdminUser user;
  final bool isAdmin;
  final String? avatarSignedUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.sagePale,
              border: Border.all(
                  color: AppTheme.sageClair.withValues(alpha: 0.4),
                  width: 1.5),
            ),
            child: ClipOval(
              child: avatarSignedUrl != null
                  ? Image.network(
                      avatarSignedUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, e, s) => const Icon(
                          Icons.person_rounded,
                          size: 26,
                          color: AppTheme.sage),
                    )
                  : const Icon(Icons.person_rounded,
                      size: 26, color: AppTheme.sage),
            ),
          ),
          const SizedBox(width: 14),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.username ?? user.email,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textePrincipal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.sage.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'admin',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.sage,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (user.username != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.texteTertaire,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 2),
                Text(
                  DateFormat('d MMMM yyyy',
                          Localizations.localeOf(context).toString())
                      .format(user.createdAt),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.texteTertaire,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Admin role card ──────────────────────────────────────────────────────────

class _AdminRoleCard extends StatelessWidget {
  const _AdminRoleCard({required this.isAdmin, required this.onToggle});

  final bool isAdmin;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                isAdmin ? Icons.shield_rounded : Icons.shield_outlined,
                size: 20,
                color: isAdmin ? AppTheme.sage : AppTheme.texteSecondaire,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isAdmin ? 'Retirer les droits admin' : 'Accorder les droits admin',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isAdmin ? Colors.red.shade400 : AppTheme.textePrincipal,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
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

// ─── Stats card ───────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.user,
    required this.entrees,
    required this.l10n,
  });

  final AdminUser user;
  final List<Entree> entrees;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final premierDate = entrees.isNotEmpty
        ? DateFormat('d MMMM yyyy',
                Localizations.localeOf(context).toString())
            .format(entrees.last.dateCreation)
        : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sage.withValues(alpha: 0.15),
            AppTheme.lucioleOr.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.lucioleCount}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrincipal,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.profilStatsSection,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.texteSecondaire,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (premierDate != null) ...[
                const SizedBox(height: 2),
                Text(
                  l10n.profilDepuis(premierDate),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.texteTertaire,
                  ),
                ),
              ],
            ],
          ),
          const Spacer(),
          Text(
            '✦',
            style: TextStyle(
              fontSize: 40,
              color: AppTheme.lucioleOr,
              shadows: [
                Shadow(
                  color: AppTheme.lucioleOr.withValues(alpha: 0.5),
                  blurRadius: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Fil header ───────────────────────────────────────────────────────────────

class _FilHeader extends StatelessWidget {
  const _FilHeader({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        l10n.profilFilSection.toUpperCase(),
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

// ─── Bottom sheet admin ───────────────────────────────────────────────────────

class _AdminEntreeBottomSheet extends StatelessWidget {
  const _AdminEntreeBottomSheet({
    required this.entree,
    required this.l10n,
    required this.onRestreindre,
    required this.onApprouver,
  });

  final Entree entree;
  final AppLocalizations l10n;
  final VoidCallback onRestreindre;
  final VoidCallback onApprouver;

  void _confirmer(BuildContext context) {
    final restrict = !entree.isRestricted;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          restrict ? l10n.adminLucioleRestrictTitre : l10n.adminLucioleApprouverTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          restrict ? l10n.adminLucioleRestrictMsg : l10n.adminLucioleApprouverMsg,
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
              l10n.filSupprimerAnnuler,
              style: GoogleFonts.inter(color: AppTheme.texteSecondaire),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (restrict) {
                onRestreindre();
              } else {
                onApprouver();
              }
            },
            child: Text(
              l10n.carteDatePickerConfirmer,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: restrict ? Colors.red.shade400 : AppTheme.sage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM yyyy',
        Localizations.localeOf(context).toString());

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (ctx, scrollController) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.creme,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.cremeTres,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Contenu scrollable
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête : date + badge restreinte
                    Row(
                      children: [
                        Text(
                          dateFormat.format(entree.dateCreation),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.texteSecondaire,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        if (entree.isRestricted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: Colors.red.shade200),
                            ),
                            child: Text(
                              l10n.adminSignalementsTagRestreinte
                                  .toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade400,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Texte complet
                    Text(
                      entree.texte,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 17,
                        color: AppTheme.textePrincipal,
                        height: 1.7,
                      ),
                    ),

                    // Photo
                    if (entree.photoUrl != null) ...[
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          entree.photoUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const SizedBox.shrink(),
                        ),
                      ),
                    ],

                    // Lieu
                    if (entree.aLieu) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined,
                              size: 14, color: AppTheme.terracotta),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              entree.lieuAffichage,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.terracotta,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bouton action
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: entree.isRestricted
                      ? ElevatedButton.icon(
                          onPressed: () => _confirmer(context),
                          icon: const Icon(Icons.check_rounded, size: 16),
                          label: Text(l10n.adminSignalementsApprouver),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.sage,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: () => _confirmer(context),
                          icon: const Icon(Icons.block_rounded, size: 16),
                          label: Text(l10n.adminSignalementsRestreindre),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade400,
                            side: BorderSide(color: Colors.red.shade200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            textStyle: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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

// ─── Séparateur année ─────────────────────────────────────────────────────────

class _SeparateurAnnee extends StatelessWidget {
  const _SeparateurAnnee({required this.annee});
  final int annee;

  @override
  Widget build(BuildContext context) {
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
          const Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }
}
