import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/locale_controller.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Accueil — CEO mock (image 2): cream canvas, centered gold logo,
/// pill search, map with floating controls, parcours card + dots.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cardPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours;
    final top = MediaQuery.paddingOf(context).top;
    final headerH = top + 112.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF4),
      body: Column(
        children: [
          // ── Teal header: centered logo + lang top-right ──
          SizedBox(
            height: headerH,
            width: double.infinity,
            child: ColoredBox(
              color: AppColors.primaryTeal,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: top + 8,
                    bottom: 14,
                    child: Center(
                      child: Image.asset(
                        AppAssets.logoGold,
                        height: 78,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Text(
                          'EcoAR',
                          style: AppFonts.playfair(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: top + 14,
                    right: 16,
                    child: const _HomeLangSwitcher(),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
              children: [
                Text(
                  'Bienvenue à Kerkennah',
                  style: AppFonts.playfair(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTeal,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explorez le patrimoine culturel des îles autrement',
                  style: AppFonts.dmSans(
                    color: const Color(0xFF6B7A86),
                    height: 1.45,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 20),

                AppSearchField(onTap: () => AppNav.goMap(context)),
                const SizedBox(height: 18),

                _HomeMap(onOpenMap: () => AppNav.goMap(context)),
                const SizedBox(height: 18),

                SizedBox(
                  height: 176,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: parcours.length,
                    onPageChanged: (i) => setState(() => _cardPage = i),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _RecommendedCard(
                          parcours: parcours[i],
                          onDiscover: () => AppNav.goParcours(context),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                PageDots(
                  count: parcours.length.clamp(1, 4),
                  index: _cardPage.clamp(0, parcours.length - 1),
                  onTap: (i) {
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
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

class _HomeLangSwitcher extends StatelessWidget {
  const _HomeLangSwitcher();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        const langs = ['AR', 'FR', 'EN'];
        final current = LocaleController.instance.code;
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primaryTeal.withValues(alpha: 0.35),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final lang in langs)
                GestureDetector(
                  onTap: () => LocaleController.instance.setCode(lang),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: lang == current
                          ? AppColors.gold
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lang,
                      style: AppFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: lang == current
                            ? AppColors.primaryTeal
                            : Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeMap extends StatelessWidget {
  const _HomeMap({required this.onOpenMap});

  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenMap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: AspectRatio(
            // Landscape Kerkennah islands map asset (~1024×657).
            aspectRatio: 1.45,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppAssets.bgMap,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF7EC8D4),
                    alignment: Alignment.center,
                    child: Text(
                      'Carte Kerkennah',
                      style: AppFonts.dmSans(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                // Floating map controls — vertical pill (CEO mock)
                Positioned(
                  right: 12,
                  bottom: 14,
                  child: Material(
                    color: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(14),
                    child: SizedBox(
                      width: 42,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _MapCtrlIcon(
                            icon: Icons.near_me_rounded,
                            onTap: onOpenMap,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _MapCtrlIcon(
                            icon: Icons.add_rounded,
                            onTap: onOpenMap,
                          ),
                          const Divider(height: 1, thickness: 1),
                          _MapCtrlIcon(
                            icon: Icons.remove_rounded,
                            onTap: onOpenMap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MapCtrlIcon extends StatelessWidget {
  const _MapCtrlIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 40,
        child: Icon(icon, size: 20, color: AppColors.primaryTeal),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.parcours,
    required this.onDiscover,
  });

  final Parcours parcours;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 108,
                child: Image.asset(
                  parcours.imageAsset,
                  fit: BoxFit.cover,
                  width: 108,
                  height: 156,
                  errorBuilder: (_, __, ___) =>
                      Container(width: 108, height: 156, color: const Color(0xFFE8E4DC)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parcours recommandé',
                    style: AppFonts.dmSans(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    parcours.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.playfair(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 14,
                        color: Color(0xFF6B7A86),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${parcours.places} lieux',
                        style: AppFonts.dmSans(
                          fontSize: 11.5,
                          color: const Color(0xFF6B7A86),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 14,
                        color: Color(0xFF6B7A86),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        parcours.duration,
                        style: AppFonts.dmSans(
                          fontSize: 11.5,
                          color: const Color(0xFF6B7A86),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: onDiscover,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Découvrir le parcours',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.chevron_right_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
