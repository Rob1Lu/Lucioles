import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/admin_user.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';
import 'admin_user_detail_screen.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().chargerUtilisateurs();
    });
    _searchController.addListener(
      () => setState(() => _query = _searchController.text),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<AdminProvider>(
      builder: (context, admin, _) {
        final liste = admin.filtrer(_query);

        return Scaffold(
          backgroundColor: AppTheme.creme,
          appBar: AppBar(
            title: Text(
              _query.isEmpty
                  ? l10n.adminUsersTitle
                  : '${l10n.adminUsersTitle} (${liste.length})',
            ),
            backgroundColor: AppTheme.creme,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
          ),
          body: Column(
            children: [
              // ── Barre de recherche ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppTheme.textePrincipal,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.adminUsersRecherche,
                    hintStyle:
                        GoogleFonts.inter(color: AppTheme.texteTertaire),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 20, color: AppTheme.texteSecondaire),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded,
                                size: 18, color: AppTheme.texteSecondaire),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.7),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                      borderSide:
                          BorderSide(color: AppTheme.sage, width: 1.5),
                    ),
                  ),
                ),
              ),

              // ── Liste ───────────────────────────────────────────────────
              Expanded(
                child: admin.chargementUtilisateurs
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.sage,
                        ),
                      )
                    : liste.isEmpty
                        ? Center(
                            child: Text(
                              l10n.adminUsersVide,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.texteSecondaire,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                            itemCount: liste.length,
                            separatorBuilder: (ctx, i) =>
                                const SizedBox(height: 6),
                            itemBuilder: (context, index) => _UserItem(
                              user: liste[index],
                              onDetail: () => _ouvrirDetail(
                                  context, admin, liste[index]),
                              onSupprimer: () => _confirmerSuppression(
                                  context, admin, l10n, liste[index]),
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _ouvrirDetail(
      BuildContext context, AdminProvider admin, AdminUser user) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider.value(
        value: admin,
        child: AdminUserDetailScreen(user: user),
      ),
    ));
  }

  void _confirmerSuppression(
    BuildContext context,
    AdminProvider admin,
    AppLocalizations l10n,
    AdminUser user,
  ) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.creme,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.adminUsersSupprimerTitre,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textePrincipal,
          ),
        ),
        content: Text(
          l10n.adminUsersSupprimerMessage(user.displayName),
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
                style:
                    GoogleFonts.inter(color: AppTheme.texteSecondaire)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await admin.supprimerUtilisateur(user.id);
            },
            child: Text(
              l10n.filSupprimerConfirmer,
              style: GoogleFonts.inter(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Item utilisateur ─────────────────────────────────────────────────────────

class _UserItem extends StatelessWidget {
  const _UserItem({
    required this.user,
    required this.onDetail,
    required this.onSupprimer,
  });

  final AdminUser user;
  final VoidCallback onDetail;
  final VoidCallback onSupprimer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: onDetail,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Avatar placeholder
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.sagePale,
                  border: Border.all(
                      color: AppTheme.sageClair.withValues(alpha: 0.4),
                      width: 1.5),
                ),
                child: const Icon(Icons.person_rounded,
                    size: 20, color: AppTheme.sage),
              ),
              const SizedBox(width: 12),

              // Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textePrincipal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user.isAdmin) ...[
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
                      '${user.lucioleCount} luciole${user.lucioleCount != 1 ? 's' : ''}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.texteSecondaire,
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton supprimer
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 18, color: Colors.red.shade300),
                onPressed: onSupprimer,
                tooltip: 'Supprimer',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                    minWidth: 36, minHeight: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
