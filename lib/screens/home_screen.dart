import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../l10n/locale_controller.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Accueil — matches CEO Home mock exactly.
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
    final size = MediaQuery.sizeOf(context);
    // Tall teal header + large logo — same as Mes favoris.
    final headerH = top + size.height * 0.20;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Teal header: large left logo + AR/FR/EN ──
          SizedBox(
            height: headerH,
            width: double.infinity,
            child: ColoredBox(
              color: const Color(0xFF123F4A),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, top + 4, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          AppAssets.logoGold,
                          height: 92,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                          errorBuilder: (_, __, ___) => Text(
                            'EcoAR',
                            style: AppFonts.playfair(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _HomeLangSwitcher(),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
              children: [
                // Welcome + Méliès
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
                              color: const Color(0xFF123F4A),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Explorez le patrimoine culturel des îles autrement',
                            style: AppFonts.dmSans(
                              color: const Color(0xFF5B6670),
                              height: 1.4,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 2, left: 8),
                      child: MeliesLogo(height: 36),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Search
                AppSearchField(onTap: () => AppNav.goMap(context)),
                const SizedBox(height: 16),

                // Interactive map
                _HomeMap(onOpenMap: () => AppNav.goMap(context)),
                const SizedBox(height: 16),

                // Recommended parcours carousel (horizontal cards)
                SizedBox(
                  height: 168,
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
                const SizedBox(height: 12),
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
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final lang in langs)
                GestureDetector(
                  onTap: () => LocaleController.instance.setCode(lang),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: lang == current
                          ? const Color(0xFFC9A227)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      lang,
                      style: AppFonts.dmSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: lang == current
                            ? const Color(0xFF123F4A)
                            : Colors.white,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          // Tall map like the CEO home mock.
          aspectRatio: 1.15,
          child: Image.asset(
            AppAssets.bgMap,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF7EC8D4),
              alignment: Alignment.center,
              child: Text(
                'Carte Kerkennah',
                style: AppFonts.dmSans(
                  color: const Color(0xFF123F4A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
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
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFECEAE4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          // Left thumbnail
          SizedBox(
            width: 118,
            child: Image.asset(
              parcours.imageAsset,
              fit: BoxFit.cover,
              height: double.infinity,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE8E4DC),
              ),
            ),
          ),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parcours recommandé',
                    style: AppFonts.dmSans(
                      color: const Color(0xFFC9A227),
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    parcours.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF123F4A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.place_outlined,
                        size: 13,
                        color: Color(0xFF5B6670),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${parcours.places} lieux',
                        style: AppFonts.dmSans(
                          fontSize: 11,
                          color: const Color(0xFF5B6670),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Color(0xFF5B6670),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        parcours.duration,
                        style: AppFonts.dmSans(
                          fontSize: 11,
                          color: const Color(0xFF5B6670),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      parcours.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.dmSans(
                        fontSize: 11,
                        height: 1.3,
                        color: const Color(0xFF5B6670),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onDiscover,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF123F4A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                                fontSize: 11,
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
