import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_index < 2) {
      _goTo(_index + 1);
    } else {
      context.go('/login');
    }
  }

  void _skip() => context.go('/login');

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),
        children: [
          _OnboardingPage1(bottom: bottom, onNext: _next, onDotTap: _goTo),
          _OnboardingPage2(
            bottom: bottom,
            onNext: _next,
            onSkip: _skip,
            onDotTap: _goTo,
          ),
          _OnboardingPage3(
            bottom: bottom,
            onStart: _next,
            onSkip: _skip,
            onDotTap: _goTo,
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.index,
    required this.onTap,
    this.overPhoto = false,
  });

  final int index;
  final ValueChanged<int> onTap;
  /// When true, inactive dots are light so they read on dark photo vignette.
  final bool overPhoto;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == index;
        return GestureDetector(
          onTap: () => onTap(i),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: active ? 9 : 8,
              height: active ? 9 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.gold
                    : (overPhoto
                        ? AppColors.white.withValues(alpha: 0.55)
                        : const Color(0xFFD0D5D8)),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Pill-outline "Passer" — white text + thin white border (screens 2 & 3 only).
class _SkipPill extends StatelessWidget {
  const _SkipPill({required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.9), width: 1),
        shape: const StadiumBorder(),
      ),
      child: Text(
        'Passer',
        style: AppFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: AppColors.white,
        ),
      ),
    );
  }
}

/// Screen 1 — logo + left copy on cream; photo flush L/R/bottom with
/// rounded top; dots + Suivant overlaid on a bottom vignette.
class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1({
    required this.bottom,
    required this.onNext,
    required this.onDotTap,
  });

  final double bottom;
  final VoidCallback onNext;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return ColoredBox(
      color: AppColors.cream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(28, topPad + 12, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: EcoLogo(height: 56, showSubtitle: true),
                ),
                const SizedBox(height: 28),
                Text(
                  'Découvrez Kerkennah autrement',
                  textAlign: TextAlign.left,
                  style: AppFonts.playfair(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Explorez un patrimoine riche grâce à la réalité augmentée et des contenus immersifs.',
                  textAlign: TextAlign.left,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        AppAssets.bgBoat,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.15),
                      ),
                      // Bottom vignette so dots + white button label stay legible
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.55),
                            ],
                            stops: const [0.45, 0.72, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 18 + bottom,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _Dots(index: 0, onTap: onDotTap, overPhoto: true),
                      const SizedBox(height: 14),
                      PrimaryButton(label: 'Suivant', onPressed: onNext),
                    ],
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

/// Screen 2 — full-bleed photo + Passer pill + bottom cream card.
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2({
    required this.bottom,
    required this.onNext,
    required this.onSkip,
    required this.onDotTap,
  });

  final double bottom;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.bgVillage, fit: BoxFit.cover),
        Container(color: Colors.black.withValues(alpha: 0.14)),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 72),
                    const Expanded(
                      child: EcoLogo(
                        compact: true,
                        height: 44,
                        showSubtitle: false,
                      ),
                    ),
                    _SkipPill(onSkip: onSkip),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 28, 24, 20 + bottom),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        border: Border.all(color: AppColors.gold, width: 1.5),
                      ),
                      child: const PackIcon(
                        AppAssets.iconLandmarkGold,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scannez, explorez, découvrez',
                      textAlign: TextAlign.center,
                      style: AppFonts.playfair(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Identifiez les lieux patrimoniaux et accédez à leurs histoires uniques.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _Dots(index: 1, onTap: onDotTap),
                    const SizedBox(height: 14),
                    PrimaryButton(label: 'Suivant', onPressed: onNext),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Screen 3 — full-bleed harbor, overlay copy, cream icon card, Commencer.
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3({
    required this.bottom,
    required this.onStart,
    required this.onSkip,
    required this.onDotTap,
  });

  final double bottom;
  final VoidCallback onStart;
  final VoidCallback onSkip;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.bgCoast, fit: BoxFit.cover),
        // Scrim so dark-teal headline stays legible over the photo
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.white.withValues(alpha: 0.62),
                Colors.white.withValues(alpha: 0.28),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.75],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 72),
                    const Expanded(
                      child: EcoLogo(
                        compact: true,
                        height: 44,
                        showSubtitle: false,
                      ),
                    ),
                    _SkipPill(onSkip: onSkip),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text(
                      "Vivez l'histoire de Kerkennah",
                      textAlign: TextAlign.center,
                      style: AppFonts.playfair(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Des parcours thématiques pour une découverte immersive du patrimoine.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 26, 20, 20 + bottom),
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _FeatureIcon(
                          asset: AppAssets.iconPalm,
                          label: 'Patrimoine',
                          tint: AppColors.gold,
                        ),
                        _FeatureIcon(
                          asset: AppAssets.iconVase,
                          label: 'Culture',
                          tint: AppColors.gold,
                        ),
                        _FeatureIcon(
                          asset: AppAssets.iconBoatGold,
                          label: 'Traditions',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _Dots(index: 2, onTap: onDotTap),
                    const SizedBox(height: 14),
                    PrimaryButton(label: 'Commencer', onPressed: onStart),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({
    required this.asset,
    required this.label,
    this.tint,
  });

  final String asset;
  final String label;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.6),
            color: AppColors.white,
          ),
          child: Center(child: PackIcon(asset, size: 30, color: tint)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.playfair(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}
