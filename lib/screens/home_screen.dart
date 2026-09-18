import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cardPage = 0;

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours;
    final featured = parcours[_cardPage.clamp(0, parcours.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const TealHeader(showBack: false, showLanguage: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bienvenue à Kerkennah',
                            style: AppFonts.playfair(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Explorez le patrimoine culturel des îles autrement',
                            style: AppFonts.dmSans(
                              color: AppColors.textSecondary,
                              height: 1.4,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4, left: 8),
                      child: MeliesLogo(height: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppLayout.softShadow,
                  ),
                  child: AppSearchField(onTap: () => AppNav.goMap(context)),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppLayout.radiusCard),
                  child: AspectRatio(
                    aspectRatio: 16 / 11,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(AppAssets.bgMap, fit: BoxFit.cover),
                        const Positioned(
                          left: 48,
                          top: 52,
                          child: _MapPin(asset: AppAssets.iconLandmark),
                        ),
                        const Positioned(
                          right: 72,
                          top: 70,
                          child: _MapPin(asset: AppAssets.iconAnchor),
                        ),
                        const Positioned(
                          left: 110,
                          bottom: 58,
                          child: _MapPin(asset: AppAssets.iconPinGold),
                        ),
                        const Positioned(
                          right: 48,
                          bottom: 72,
                          child: _MapPin(fallbackIcon: Icons.lightbulb_outline),
                        ),
                        Positioned(
                          left: 20,
                          top: 24,
                          child: Text(
                            'Île Chergui',
                            style: AppFonts.dmSans(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 28,
                          bottom: 36,
                          child: Text(
                            'Île Gharbi',
                            style: AppFonts.dmSans(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Column(
                            children: [
                              SoftCircleButton(
                                asset: AppAssets.iconNav,
                                onPressed: () => AppNav.goMap(context),
                              ),
                              const SizedBox(height: 8),
                              SoftCircleButton(
                                icon: Icons.add,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 8),
                              SoftCircleButton(
                                icon: Icons.remove,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: SoftCircleButton(
                            icon: Icons.my_location,
                            background: AppColors.navy,
                            foreground: AppColors.white,
                            onPressed: () => AppNav.goMap(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _RecommendedCard(
                  parcours: featured,
                  onDiscover: () => AppNav.openParcoursDetail(context),
                ),
                const SizedBox(height: 14),
                PageDots(
                  count: parcours.length.clamp(1, 4),
                  index: _cardPage.clamp(0, parcours.length - 1),
                  onTap: (i) => setState(
                    () => _cardPage = i.clamp(0, parcours.length - 1),
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

class _MapPin extends StatelessWidget {
  const _MapPin({this.asset, this.fallbackIcon});
  final String? asset;
  final IconData? fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 6),
        ],
      ),
      child: Center(
        child: asset != null
            ? PackIcon(asset!, size: 18, color: AppColors.white)
            : Icon(
                fallbackIcon ?? Icons.place,
                size: 16,
                color: AppColors.white,
              ),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({required this.parcours, required this.onDiscover});
  final Parcours parcours;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppLayout.radiusCard),
        boxShadow: AppLayout.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(parcours.imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Parcours recommandé',
            style: AppFonts.dmSans(
              color: AppColors.gold,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            parcours.title,
            style: AppFonts.playfair(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${parcours.places} lieux · ${parcours.duration}',
            style: AppFonts.dmSans(fontSize: 13, color: AppColors.navy),
          ),
          const SizedBox(height: 6),
          Text(
            parcours.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.dmSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Découvrir le parcours',
            onPressed: onDiscover,
          ),
        ],
      ),
    );
  }
}
