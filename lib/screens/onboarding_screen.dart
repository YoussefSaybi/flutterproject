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

  void _next() {
    if (_index < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 340),
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  void _skip() => context.go('/login');

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            children: [
              _OnboardingPage1(bottom: bottom, onNext: _next),
              _OnboardingPage2(bottom: bottom, onNext: _next, onSkip: _skip),
              _OnboardingPage3(bottom: bottom, onStart: _next, onSkip: _skip),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.index, this.dark = false});
  final int index;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == index;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? AppColors.gold
                : (dark
                    ? AppColors.border
                    : AppColors.white.withValues(alpha: 0.55)),
          ),
        );
      }),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        side: BorderSide(color: AppColors.white.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text('Passer', style: AppFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}

/// Page 1 — full scenic bg, navy copy, bottom CTA (matches onboarding_1).
class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1({required this.bottom, required this.onNext});
  final double bottom;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.bgBoat, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.35),
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.55),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 24 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: EcoLogo(height: 64)),
                const SizedBox(height: 36),
                Text(
                  'Découvrez Kerkennah autrement',
                  textAlign: TextAlign.left,
                  style: AppFonts.playfair(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Explorez un patrimoine riche grâce à la réalité augmentée et des contenus immersifs.',
                  textAlign: TextAlign.left,
                  style: AppFonts.dmSans(
                    fontSize: 15,
                    color: AppColors.textPrimary,
                    height: 1.45,
                  ),
                ),
                const Spacer(),
                const Center(child: _Dots(index: 0, dark: true)),
                const SizedBox(height: 18),
                PrimaryButton(label: 'Suivant', onPressed: onNext),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Page 2 — QR frame mid-screen + cream bottom sheet (matches onboarding_2).
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2({
    required this.bottom,
    required this.onNext,
    required this.onSkip,
  });
  final double bottom;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.bgVillage, fit: BoxFit.cover),
        Container(color: Colors.black.withValues(alpha: 0.12)),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 72),
                    const Expanded(child: EcoLogo(height: 52)),
                    _SkipButton(onSkip: onSkip),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              const _QrFrameIllustration(),
              const Spacer(flex: 3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 28, 24, 22 + bottom),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withValues(alpha: 0.15),
                        border: Border.all(color: AppColors.gold, width: 1.5),
                      ),
                      child: const PackIcon(AppAssets.iconLandmarkGold, size: 28),
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
                    const SizedBox(height: 20),
                    const _Dots(index: 1, dark: true),
                    const SizedBox(height: 18),
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

class _QrFrameIllustration extends StatelessWidget {
  const _QrFrameIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.qr_code_2_rounded, size: 100, color: AppColors.navy),
          ),
          CustomPaint(
            size: const Size(200, 200),
            painter: _CornerFramePainter(color: AppColors.white, stroke: 4, length: 36),
          ),
        ],
      ),
    );
  }
}

/// Page 3 — mid copy + cream feature sheet (matches onboarding_3).
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3({
    required this.bottom,
    required this.onStart,
    required this.onSkip,
  });
  final double bottom;
  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AppAssets.bgCoast, fit: BoxFit.cover),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.white.withValues(alpha: 0.45),
                Colors.transparent,
              ],
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
                    const Expanded(child: EcoLogo(height: 52)),
                    _SkipButton(onSkip: onSkip),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text(
                      'Vivez l’histoire de Kerkennah',
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
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 26, 20, 22 + bottom),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _FeatureIcon(
                          asset: AppAssets.iconLandmarkGold,
                          label: 'Patrimoine',
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
                    const SizedBox(height: 22),
                    const _Dots(index: 2, dark: true),
                    const SizedBox(height: 18),
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
          child: Center(
            child: PackIcon(asset, size: 30, color: tint),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppFonts.playfair(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
      ],
    );
  }
}

class _CornerFramePainter extends CustomPainter {
  _CornerFramePainter({
    required this.color,
    required this.stroke,
    required this.length,
  });

  final Color color;
  final double stroke;
  final double length;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    void corner(double x, double y, double dx, double dy) {
      canvas.drawLine(Offset(x, y), Offset(x + dx * length, y), paint);
      canvas.drawLine(Offset(x, y), Offset(x, y + dy * length), paint);
    }

    corner(0, 0, 1, 1);
    corner(size.width, 0, -1, 1);
    corner(0, size.height, 1, -1);
    corner(size.width, size.height, -1, -1);
  }

  @override
  bool shouldRepaint(covariant _CornerFramePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.stroke != stroke ||
      oldDelegate.length != length;
}
