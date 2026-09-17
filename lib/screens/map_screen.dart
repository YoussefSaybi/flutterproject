import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, top + 10, 16, 16),
            color: AppColors.navy,
            child: const EcoLogo(compact: true, height: 44),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.bgMap, fit: BoxFit.cover),
                const Positioned(left: 90, top: 160, child: PackIcon(AppAssets.iconLandmarkGold, size: 40)),
                const Positioned(right: 110, top: 120, child: PackIcon(AppAssets.iconAnchor, size: 36)),
                const Positioned(left: 180, bottom: 180, child: PackIcon(AppAssets.iconPinGold, size: 40)),
                Positioned(
                  right: 16,
                  top: 16,
                  child: Column(
                    children: [
                      SoftCircleButton(icon: Icons.near_me_outlined, onPressed: () {}),
                      const SizedBox(height: 8),
                      SoftCircleButton(icon: Icons.add, onPressed: () {}),
                      const SizedBox(height: 8),
                      SoftCircleButton(icon: Icons.remove, onPressed: () {}),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explorer la carte',
                          style: AppFonts.playfair(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Touchez un point pour ouvrir un parcours ou un récit.',
                          style: AppFonts.dmSans(color: AppColors.textSecondary, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        PrimaryButton(
                          label: 'Voir un parcours',
                          onPressed: () => AppNav.openParcoursDetail(context),
                        ),
                      ],
                    ),
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
