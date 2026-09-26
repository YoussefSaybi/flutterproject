import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/app_session.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';
import '../widgets/onboarding_micro_interactions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final p = _controller.page;
      if (p != null && p != _page) setState(() => _page = p);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 480),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_index < 2) {
      _goTo(_index + 1);
    } else {
      // ignore: unawaited_futures
      AppSession.instance.completeOnboarding();
      context.go('/home');
    }
  }

  void _skip() {
    // ignore: unawaited_futures
    AppSession.instance.completeOnboarding();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.hardEdge,
        onPageChanged: (i) => setState(() => _index = i),
        children: [
          _OnboardingPage1(
            bottom: bottom,
            active: _index == 0,
            pageDelta: _page - 0,
            onNext: _next,
            onDotTap: _goTo,
          ),
          _OnboardingPage2(
            bottom: bottom,
            active: _index == 1,
            pageDelta: _page - 1,
            onNext: _next,
            onSkip: _skip,
            onDotTap: _goTo,
          ),
          _OnboardingPage3(
            bottom: bottom,
            active: _index == 2,
            pageDelta: _page - 2,
            onStart: _next,
            onSkip: _skip,
            onDotTap: _goTo,
          ),
        ],
      ),
    );
  }
}

/// Screen 1 — full-bleed harbor photo + frosted bottom card (same language as page 2).
class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1({
    required this.bottom,
    required this.active,
    required this.pageDelta,
    required this.onNext,
    required this.onDotTap,
  });

  final double bottom;
  final bool active;
  final double pageDelta;
  final VoidCallback onNext;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        KenBurnsBackground(
          asset: AppAssets.bgOnboardingBoat,
          active: active,
        ),
        // Soft top wash for logo readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.18),
                Colors.transparent,
              ],
              stops: const [0.0, 0.35],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: ParallaxShift(
            pageDelta: pageDelta,
            factor: 22,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: OnboardingEntrance(
                    active: active,
                    child: FloatingLogo(
                      active: active,
                      child: Center(
                        child: Image.asset(
                          AppAssets.logo,
                          height: 110,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GlassSheetReveal(
                  active: active,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(36)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24, 26, 24, 20 + bottom),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.82),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedGoldGlyph(
                              pulse: active,
                              size: 64,
                              chrome: false,
                              child: Image.asset(
                                AppAssets.iconThemeDiscover,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Découvrez Kerkennah autrement',
                              textAlign: TextAlign.center,
                              style: AppFonts.playfair(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Explorez un patrimoine riche grâce à la réalité\n'
                              'augmentée et des contenus immersifs.',
                              textAlign: TextAlign.center,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            OnboardingDots(index: 0, onTap: onDotTap),
                            const SizedBox(height: 14),
                            PrimaryButton(
                              label: 'Suivant',
                              onPressed: onNext,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Screen 2 — CEO mock: full-bleed scan alley, AR corners, glass bottom card.
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2({
    required this.bottom,
    required this.active,
    required this.pageDelta,
    required this.onNext,
    required this.onSkip,
    required this.onDotTap,
  });

  final double bottom;
  final bool active;
  final double pageDelta;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    // Map QR modules on tower plaque (onboarding_scan.jpg 576×1024) via cover.
    final scanRect = _mapCoverRect(
      screen: size,
      imageSize: const Size(576, 1024),
      // Tight frame on the QR only (not the EcoAR wordmark below).
      sourceRect: const Rect.fromLTWH(391, 499, 55, 55),
      pad: 0.05,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        KenBurnsBackground(
          asset: AppAssets.bgOnboardingScan,
          active: active,
          // Keep AR corners in the same Ken Burns space as the photo.
          overlays: [
            Positioned(
              left: scanRect.left,
              top: scanRect.top,
              width: scanRect.width,
              height: scanRect.height,
              child: IgnorePointer(
                child: PulsingScanFrame(
                  active: active,
                  child: const _ArScanCorners(),
                ),
              ),
            ),
          ],
        ),
        // Soft top wash for logo + Passer readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.18),
                Colors.transparent,
              ],
              stops: const [0.0, 0.35],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: ParallaxShift(
            pageDelta: pageDelta,
            factor: 22,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 12, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 56),
                      Expanded(
                        child: OnboardingEntrance(
                          active: active,
                          child: FloatingLogo(
                            active: active,
                            child: Center(
                              child: Image.asset(
                                AppAssets.logo,
                                height: 110,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      OnboardingEntrance(
                        active: active,
                        delay: const Duration(milliseconds: 70),
                        offset: 8,
                        child: OnboardingSkipButton(onSkip: onSkip),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Frosted glass bottom sheet (matches CEO mock)
                GlassSheetReveal(
                  active: active,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(36)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24, 26, 24, 20 + bottom),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.82),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedGoldGlyph(
                              pulse: active,
                              size: 64,
                              chrome: false,
                              child: Image.asset(
                                AppAssets.iconThemeScan,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
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
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Identifiez les lieux patrimoniaux et accédez à leurs\n'
                              'histoires uniques.',
                              textAlign: TextAlign.center,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            OnboardingDots(index: 1, onTap: onDotTap),
                            const SizedBox(height: 14),
                            PrimaryButton(
                              label: 'Suivant',
                              onPressed: onNext,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Maps a rect in a cover-fitted image into screen coordinates.
Rect _mapCoverRect({
  required Size screen,
  required Size imageSize,
  required Rect sourceRect,
  double pad = 0,
}) {
  final scale = math.max(
    screen.width / imageSize.width,
    screen.height / imageSize.height,
  );
  final drawnW = imageSize.width * scale;
  final drawnH = imageSize.height * scale;
  final ox = (screen.width - drawnW) / 2;
  final oy = (screen.height - drawnH) / 2;
  final padX = sourceRect.width * pad;
  final padY = sourceRect.height * pad;
  return Rect.fromLTRB(
    ox + (sourceRect.left - padX) * scale,
    oy + (sourceRect.top - padY) * scale,
    ox + (sourceRect.right + padX) * scale,
    oy + (sourceRect.bottom + padY) * scale,
  );
}

/// White L-corners framing the QR plaque (AR scanner cue).
class _ArScanCorners extends StatelessWidget {
  const _ArScanCorners();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ArCornersPainter());
  }
}

class _ArCornersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final len = size.shortestSide * 0.22;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, len)
        ..lineTo(0, 0)
        ..lineTo(len, 0),
      paint,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(w - len, 0)
        ..lineTo(w, 0)
        ..lineTo(w, len),
      paint,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, h - len)
        ..lineTo(0, h)
        ..lineTo(len, h),
      paint,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(w - len, h)
        ..lineTo(w, h)
        ..lineTo(w, h - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Screen 3 — CEO mock: harbor photo, sky copy, wavy cream sheet + feature icons.
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3({
    required this.bottom,
    required this.active,
    required this.pageDelta,
    required this.onStart,
    required this.onSkip,
    required this.onDotTap,
  });

  final double bottom;
  final bool active;
  final double pageDelta;
  final VoidCallback onStart;
  final VoidCallback onSkip;
  final ValueChanged<int> onDotTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        KenBurnsBackground(
          asset: AppAssets.bgOnboardingHarbor,
          active: active,
          alignment: const Alignment(0, -0.08),
        ),
        // Soft top wash for logo + Passer readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.black.withValues(alpha: 0.22),
                Colors.transparent,
              ],
              stops: const [0.0, 0.38],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: ParallaxShift(
            pageDelta: pageDelta,
            factor: 22,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 12, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 56),
                      Expanded(
                        child: OnboardingEntrance(
                          active: active,
                          child: FloatingLogo(
                            active: active,
                            child: Center(
                              child: Image.asset(
                                AppAssets.logo,
                                height: 110,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      OnboardingEntrance(
                        active: active,
                        delay: const Duration(milliseconds: 70),
                        offset: 8,
                        child: OnboardingSkipButton(onSkip: onSkip),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GlassSheetReveal(
                  active: active,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(36)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(24, 26, 24, 20 + bottom),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.92),
                              const Color(0xFFF5EFE4).withValues(alpha: 0.94),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: 0.95),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _ThemeFeatureIcon(
                                  kind: _ThemeIconKind.patrimoine,
                                  delay: const Duration(milliseconds: 200),
                                  active: active,
                                  pulse: active,
                                ),
                                _ThemeFeatureIcon(
                                  kind: _ThemeIconKind.culture,
                                  delay: const Duration(milliseconds: 280),
                                  active: active,
                                  pulse: active,
                                ),
                                _ThemeFeatureIcon(
                                  kind: _ThemeIconKind.traditions,
                                  delay: const Duration(milliseconds: 360),
                                  active: active,
                                  pulse: active,
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "Vivez l'histoire de Kerkennah",
                              textAlign: TextAlign.center,
                              style: AppFonts.playfair(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Des parcours thématiques pour une découverte\n'
                              'immersive du patrimoine.',
                              textAlign: TextAlign.center,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            OnboardingDots(index: 2, onTap: onDotTap),
                            const SizedBox(height: 14),
                            PrimaryButton(
                              label: 'Commencer',
                              onPressed: onStart,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum _ThemeIconKind { patrimoine, culture, traditions }

extension on _ThemeIconKind {
  String get asset => switch (this) {
        _ThemeIconKind.patrimoine => AppAssets.iconThemePatrimoine,
        _ThemeIconKind.culture => AppAssets.iconThemeCulture,
        _ThemeIconKind.traditions => AppAssets.iconThemeTraditions,
      };
}

class _ThemeFeatureIcon extends StatelessWidget {
  const _ThemeFeatureIcon({
    required this.kind,
    required this.active,
    this.delay = Duration.zero,
    this.pulse = false,
    this.size = 52,
  });

  final _ThemeIconKind kind;
  final bool active;
  final Duration delay;
  final bool pulse;
  final double size;

  @override
  Widget build(BuildContext context) {
    return OnboardingEntrance(
      active: active,
      delay: delay,
      offset: 18,
      scaleFrom: 0.88,
      child: AnimatedGoldGlyph(
        pulse: pulse,
        size: size,
        chrome: false,
        child: Image.asset(
          kind.asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
