import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ArLightScreen extends StatelessWidget {
  const ArLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgBoat, fit: BoxFit.cover),
          Positioned(
            top: top + 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                SoftCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  background: Colors.black.withValues(alpha: 0.4),
                  foreground: AppColors.white,
                  size: 42,
                  onPressed: () => AppNav.popOr(context, '/scanner'),
                ),
                const Expanded(
                  child: Center(child: EcoLogo(compact: true, height: 40)),
                ),
                SoftCircleButton(
                  icon: Icons.menu_rounded,
                  background: Colors.black.withValues(alpha: 0.4),
                  foreground: AppColors.white,
                  size: 42,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 56,
                  color: AppColors.gold.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 108 + bottom,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 18),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(AppLayout.radiusCard),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Charfiya traditionnelle',
                          style: AppFonts.playfair(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SoftCircleButton(
                        icon: Icons.close_rounded,
                        background: Colors.white.withValues(alpha: 0.12),
                        foreground: AppColors.white,
                        size: 34,
                        onPressed: () =>
                            AppNav.popOr(context, '/scanner'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Embarcation emblématique de Kerkennah, utilisée par les pêcheurs depuis des générations.',
                    style: AppFonts.dmSans(
                      color: Colors.white70,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(label: 'Patrimoine maritime'),
                      _Tag(label: 'Savoir-faire local'),
                      _Tag(label: 'Île Chergui'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: "Écouter l'histoire",
                    icon: Icons.volume_up_rounded,
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.navy,
                    onPressed: () => AppNav.openAudio(context),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 18 + bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ArNavButton(
                  icon: Icons.map_outlined,
                  label: 'Carte',
                  onTap: () => AppNav.goMap(context),
                ),
                _ArNavButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scanner',
                  large: true,
                  onTap: () => AppNav.popOr(context, '/scanner'),
                ),
                _ArNavButton(
                  icon: Icons.info_outline_rounded,
                  label: 'À propos',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'EcoAR Kerkennah — médiation patrimoniale en réalité augmentée.',
                          style: AppFonts.dmSans(color: AppColors.white),
                        ),
                        backgroundColor: AppColors.navy,
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
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppLayout.radiusPill),
      ),
      child: Text(
        label,
        style: AppFonts.dmSans(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ArNavButton extends StatelessWidget {
  const _ArNavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 64.0 : 50.0;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.navy.withValues(alpha: large ? 0.92 : 0.78),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.22),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.white, size: large ? 28 : 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppFonts.dmSans(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
