import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

/// Profile — teal palm header image + larger white cards (CEO mock).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name = user?.name ?? 'Mohamed Azmi';
    final email = user?.email ?? 'azmi.heni@gmail.com';
    final city =
        (user?.city.isNotEmpty ?? false) ? user!.city : 'Sfax, Tunisie';
    final top = MediaQuery.paddingOf(context).top;
    final size = MediaQuery.sizeOf(context);
    // Tall header so palm shadows read big like the mock.
    final headerH = top + size.height * 0.28;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Green/teal header = user palm picture ──
            SizedBox(
              height: headerH,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.bgProfileHeader,
                    fit: BoxFit.cover,
                    // Zoom palms in top-left
                    alignment: const Alignment(-0.9, -1.0),
                    errorBuilder: (_, __, ___) => const ColoredBox(
                      color: Color(0xFF005664),
                    ),
                  ),
                  Positioned(
                    top: top + 8,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        AppAssets.logoGold,
                        height: 48,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Text(
                          'EcoAR',
                          style: AppFonts.playfair(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: top + 10,
                    right: 18,
                    child: GestureDetector(
                      onTap: () => AppNav.openEditProfile(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 1.3,
                          ),
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 22,
                    bottom: 52,
                    child: Text(
                      'Mon profil',
                      style: AppFonts.playfair(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.05,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Larger white widgets ──
            Transform.translate(
              offset: const Offset(0, -44),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  children: [
                    // Identity card
                    GestureDetector(
                      onTap: () => AppNav.openEditProfile(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 18, 12, 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 68,
                              height: 68,
                              child: ClipOval(
                                child: Stack(
                                  fit: StackFit.expand,
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      AppAssets.bgCoast,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const ColoredBox(
                                        color: Color(0xFFD8E3E8),
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black.withValues(
                                        alpha: 0.18,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.person_rounded,
                                      size: 36,
                                      color: Colors.white70,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppFonts.playfair(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF123F4A),
                                      height: 1.15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _InfoLine(
                                    icon: Icons.mail_outline_rounded,
                                    text: email,
                                  ),
                                  const SizedBox(height: 4),
                                  _InfoLine(
                                    icon: Icons.place_outlined,
                                    text: city,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFFB0B8BF),
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Stats — larger tiles
                    Row(
                      children: [
                        const _StatTile(
                          icon: Icons.place_outlined,
                          value: '12',
                          label: 'Lieux visités',
                        ),
                        const SizedBox(width: 10),
                        _StatTile(
                          icon: Icons.alt_route_rounded,
                          value: '3',
                          label: 'Parcours',
                          onTap: () => context.go('/parcours'),
                        ),
                        const SizedBox(width: 10),
                        _StatTile(
                          icon: Icons.favorite_border_rounded,
                          value: '5',
                          label: 'Favoris',
                          onTap: () => AppNav.openFavorites(context),
                        ),
                      ],
                    ),

                    // Space so menu sits lower
                    const SizedBox(height: 22),

                    // Menu card — bigger rows (Mes favoris / Mes parcours…)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _MenuRow(
                            icon: Icons.favorite_border_rounded,
                            label: 'Mes favoris',
                            onTap: () => AppNav.openFavorites(context),
                          ),
                          const _Hairline(),
                          _MenuRow(
                            icon: Icons.map_outlined,
                            label: 'Mes parcours',
                            onTap: () => context.go('/parcours'),
                          ),
                          const _Hairline(),
                          _MenuRow(
                            icon: Icons.download_outlined,
                            label: 'Mes téléchargements',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Téléchargements — bientôt disponible.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                          const _Hairline(),
                          _MenuRow(
                            icon: Icons.settings_outlined,
                            label: 'Paramètres',
                            onTap: () => AppNav.openEditProfile(context),
                          ),
                          const _Hairline(),
                          _MenuRow(
                            icon: Icons.help_outline_rounded,
                            label: 'Aide & support',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Aide & support — bientôt disponible.',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E2DA)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: const Color(0xFFC9A227)),
              const SizedBox(height: 8),
              Text(
                value,
                style: AppFonts.playfair(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF123F4A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppFonts.dmSans(
                  fontSize: 12,
                  color: const Color(0xFF5B6670),
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      endIndent: 18,
      color: Color(0xFFE6E2DA),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 24, color: const Color(0xFF123F4A)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF123F4A),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: Color(0xFFB0B8BF),
            ),
          ],
        ),
      ),
    );
  }
}
