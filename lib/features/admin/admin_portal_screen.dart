import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/admin_provider.dart';
import 'admin_signalements_screen.dart';
import 'admin_users_screen.dart';

class AdminPortalScreen extends StatefulWidget {
  const AdminPortalScreen({super.key});

  @override
  State<AdminPortalScreen> createState() => _AdminPortalScreenState();
}

class _AdminPortalScreenState extends State<AdminPortalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().chargerStats();
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
            title: Text(l10n.adminPortalTitle),
            backgroundColor: AppTheme.creme,
            scrolledUnderElevation: 1,
            shadowColor: AppTheme.sageClair.withValues(alpha: 0.3),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              // ── Stats ──────────────────────────────────────────────────────
              _TitreSectionAdmin(titre: l10n.adminPortalStats),
              _StatsCard(admin: admin),

              // ── Navigation ─────────────────────────────────────────────────
              const SizedBox(height: 8),
              _TitreSectionAdmin(titre: l10n.adminPortalGestion),
              _NavCard(
                icon: Icons.people_outline_rounded,
                label: l10n.adminPortalUtilisateurs,
                onTap: () => _ouvrirUtilisateurs(context, admin, l10n),
              ),
              _NavCard(
                icon: Icons.flag_outlined,
                label: l10n.adminPortalSignalements,
                onTap: () => _ouvrirSignalements(context, admin),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  void _ouvrirSignalements(BuildContext context, AdminProvider admin) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider.value(
        value: admin,
        child: const AdminSignalementsScreen(),
      ),
    ));
  }

  void _ouvrirUtilisateurs(
    BuildContext context,
    AdminProvider admin,
    AppLocalizations l10n,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: admin,
          child: const AdminUsersScreen(),
        ),
      ),
    );
  }
}

// ─── Stats card ───────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.admin});
  final AdminProvider admin;

  @override
  Widget build(BuildContext context) {
    final stats = admin.stats;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.sage.withValues(alpha: 0.12),
            AppTheme.lucioleOr.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.sageClair.withValues(alpha: 0.3)),
      ),
      child: admin.chargementStats
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.sage,
                ),
              ),
            )
          : Row(
              children: [
                _StatItem(
                  valeur: stats?.userCount ?? 0,
                  label: 'utilisateurs',
                  icone: Icons.person_outline_rounded,
                ),
                Container(
                  height: 48,
                  width: 1,
                  color: AppTheme.sageClair.withValues(alpha: 0.4),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                _StatItem(
                  valeur: stats?.lucioleCount ?? 0,
                  label: 'lucioles',
                  icone: Icons.star_outline_rounded,
                ),
              ],
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.valeur,
    required this.label,
    required this.icone,
  });

  final int valeur;
  final String label;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(icone, size: 22, color: AppTheme.sage),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$valeur',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textePrincipal,
                  height: 1.0,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.texteSecondaire,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Navigation card ──────────────────────────────────────────────────────────

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: disabled ? 0.35 : 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cremeTres),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: disabled
                    ? AppTheme.texteTertaire
                    : AppTheme.texteSecondaire,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: disabled
                        ? AppTheme.texteTertaire
                        : AppTheme.textePrincipal,
                  ),
                ),
              ),
              Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppTheme.texteTertaire,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Titre de section ─────────────────────────────────────────────────────────

class _TitreSectionAdmin extends StatelessWidget {
  const _TitreSectionAdmin({required this.titre});
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
