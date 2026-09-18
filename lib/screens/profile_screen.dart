import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    final email = user?.email ?? AuthService.demoEmail;
    final city = (user?.city.isNotEmpty ?? false)
        ? user!.city
        : 'Sfax, Tunisie';
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: top + 140,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Container(color: AppColors.navy),
                  ),
                  Positioned(
                    left: -8,
                    top: top + 16,
                    child: Opacity(
                      opacity: 0.16,
                      child: PackIcon(
                        AppAssets.iconPalm,
                        size: 110,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, top + 12, 16, 52),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Mon profil',
                            style: AppFonts.playfair(
                              color: AppColors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SoftCircleButton(
                          icon: Icons.settings_outlined,
                          background: AppColors.white.withValues(alpha: 0.15),
                          foreground: AppColors.white,
                          size: 40,
                          onPressed: () => AppNav.openEditProfile(context),
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
              offset: const Offset(0, -36),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppLayout.radiusCard),
                        boxShadow: AppLayout.softShadow,
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(AppAssets.bgCoast),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            name,
                            textAlign: TextAlign.center,
                            style: AppFonts.playfair(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: AppFonts.dmSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                city,
                                style: AppFonts.dmSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const _StatColumn(
                          value: '12',
                          label: 'Lieux visités',
                        ),
                        const SizedBox(width: 8),
                        const _StatColumn(
                          value: '3',
                          label: 'Parcours',
                        ),
                        const SizedBox(width: 8),
                        _StatColumn(
                          value: '5',
                          label: 'Favoris',
                          onTap: () => AppNav.openFavorites(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppLayout.radiusCard),
                        boxShadow: AppLayout.softShadow,
                      ),
                      child: Column(
                        children: [
                          _MenuTile(
                            icon: Icons.favorite_border_rounded,
                            label: 'Mes favoris',
                            onTap: () => AppNav.openFavorites(context),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.route_outlined,
                            label: 'Mes parcours',
                            onTap: () => AppNav.openParcoursDetail(context),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.download_outlined,
                            label: 'Mes téléchargements',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.settings_outlined,
                            label: 'Paramètres',
                            onTap: () => AppNav.openEditProfile(context),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.help_outline_rounded,
                            label: 'Aide & support',
                            onTap: () {},
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.handshake_outlined,
                            label: 'Partenaires & mentions légales',
                            onTap: () => AppNav.openCredits(context),
                          ),
                          const Divider(height: 1, color: AppColors.border),
                          _MenuTile(
                            icon: Icons.logout_rounded,
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

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.value,
    required this.label,
    this.onTap,
  });

  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
            boxShadow: AppLayout.softShadow,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: AppFonts.playfair(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Icon(icon, color: AppColors.navy),
      title: Text(
        label,
        style: AppFonts.dmSans(
          color: AppColors.navy,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.navy,
      ),
    );
  }
}
