import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final name = user?.name ?? 'Mohamed Azmi';
    final top = MediaQuery.paddingOf(context).top;
    final favorisCount = MockData.favorites.length;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: top + 168,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(color: AppColors.navy),
                  ),
                  Positioned(
                    left: -10,
                    top: top + 20,
                    child: Opacity(
                      opacity: 0.18,
                      child: PackIcon(
                        AppAssets.iconPalm,
                        size: 120,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, top + 10, 16, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(child: EcoLogo(compact: true, height: 44)),
                            SoftCircleButton(
                              icon: Icons.settings_outlined,
                              background: Colors.transparent,
                              foreground: AppColors.gold,
                              onPressed: () => AppNav.openEditProfile(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Mon profil',
                          style: AppFonts.playfair(
                            color: AppColors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => AppNav.openEditProfile(context),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(AppAssets.bgCoast),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppFonts.playfair(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Explorateur des îles',
                                    style: AppFonts.dmSans(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const _Stat(icon: AppAssets.iconPinGold, value: '12', label: 'Lieux'),
                        const SizedBox(width: 8),
                        const _Stat(icon: AppAssets.iconParcoursActive, value: '3', label: 'Parcours'),
                        const SizedBox(width: 8),
                        _Stat(
                          icon: AppAssets.iconHeartActive,
                          value: '$favorisCount',
                          label: 'Favoris',
                          onTap: () => AppNav.openFavorites(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.favorite_border,
                            label: 'Mes favoris',
                            onTap: () => AppNav.openFavorites(context),
                          ),
                          const Divider(height: 1),
                          _MenuTile(
                            icon: Icons.map_outlined,
                            label: 'Mes parcours',
                            onTap: () => AppNav.openParcoursDetail(context),
                          ),
                          const Divider(height: 1),
                          _MenuTile(
                            icon: Icons.download_outlined,
                            label: 'Mes téléchargements',
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          _MenuTile(
                            icon: Icons.settings_outlined,
                            label: 'Paramètres',
                            onTap: () => AppNav.openEditProfile(context),
                          ),
                          const Divider(height: 1),
                          _MenuTile(
                            icon: Icons.help_outline,
                            label: 'Aide & support',
                            onTap: () {},
                          ),
                          const Divider(height: 1),
                          _MenuTile(
                            icon: Icons.logout,
                            label: 'Se déconnecter',
                            onTap: () {
                              AuthService.instance.logout();
                              context.go('/login');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final String icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              PackIcon(icon, size: 22),
              const SizedBox(height: 6),
              Text(
                value,
                style: AppFonts.playfair(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.navy),
      title: Text(
        label,
        style: AppFonts.dmSans(color: AppColors.navy, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
    );
  }
}
