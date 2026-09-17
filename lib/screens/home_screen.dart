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
  String _lang = 'FR';
  int _cardPage = 0;

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours;
    final featured = parcours[_cardPage.clamp(0, parcours.length - 1)];
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.navy,
              padding: EdgeInsets.fromLTRB(16, top + 10, 16, 18),
              child: Row(
                children: [
                  const Expanded(child: EcoLogo(compact: true, height: 44)),
                  LanguageSwitcher(
                    selected: _lang,
                    onChanged: (v) => setState(() => _lang = v),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 8),
                        child: Text(
                          'Méliès',
                          style: AppFonts.greatVibes(color: AppColors.gold, fontSize: 30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AppSearchField(onTap: () => AppNav.goMap(context)),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: AspectRatio(
                      aspectRatio: 16 / 11,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(AppAssets.bgMap, fit: BoxFit.cover),
                          // Decorative map pins
                          const Positioned(
                            left: 48,
                            top: 52,
                            child: _MapPin(Icons.account_balance_outlined),
                          ),
                          const Positioned(
                            right: 72,
                            top: 70,
                            child: _MapPin(Icons.anchor_outlined),
                          ),
                          const Positioned(
                            left: 110,
                            bottom: 58,
                            child: _MapPin(Icons.lightbulb_outline),
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
                                SoftCircleButton(icon: Icons.add, onPressed: () {}),
                                const SizedBox(height: 8),
                                SoftCircleButton(icon: Icons.remove, onPressed: () {}),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final active = i == _cardPage;
                      return GestureDetector(
                        onTap: () => setState(() => _cardPage = i.clamp(0, parcours.length - 1)),
                        child: Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active ? AppColors.gold : AppColors.border,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin(this.icon);
  final IconData icon;

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
      child: Icon(icon, size: 16, color: AppColors.white),
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                parcours.imageAsset,
                width: 96,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parcours recommandé',
                    style: AppFonts.dmSans(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    parcours.title,
                    style: AppFonts.playfair(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined, size: 14, color: AppColors.navy),
                      const SizedBox(width: 4),
                      Text(
                        '${parcours.places} lieux',
                        style: AppFonts.dmSans(fontSize: 12, color: AppColors.navy),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule, size: 14, color: AppColors.navy),
                      const SizedBox(width: 4),
                      Text(
                        parcours.duration,
                        style: AppFonts.dmSans(fontSize: 12, color: AppColors.navy),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    parcours.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.dmSans(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'Découvrir le parcours',
                    expand: true,
                    onPressed: onDiscover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
