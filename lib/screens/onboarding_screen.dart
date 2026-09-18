import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/app_session.dart';
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
      // ignore: unawaited_futures
      AppSession.instance.completeOnboarding();
      context.go('/login');
    }
  }

  void _skip() {
    // ignore: unawaited_futures
    AppSession.instance.completeOnboarding();
    context.go('/login');
  }

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
  });

  final int index;
  final ValueChanged<int> onTap;

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
                    : const Color(0xFFD0D5D8),
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

/// Screen 1 — exact CEO mock: full-bleed boat photo, gold logo, left copy,
/// gold dots, teal Suivant pill.
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
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.bgOnboardingBoat,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          gaplessPlayback: true,
        ),
        // Very light sky wash — keeps navy type readable, photo stays vivid
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.white.withValues(alpha: 0.28),
                Colors.white.withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0.0, 0.32, 0.58],
            ),
          ),
        ),
        // Soft white lift under CTA (matches mock bottom fade)
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.25),
                Colors.white.withValues(alpha: 0.72),
              ],
              stops: const [0.62, 0.82, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 28, 18 + bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: Center(
                    child: Image.asset(
                      AppAssets.logo,
                      width: MediaQuery.sizeOf(context).width * 0.92,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'Découvrez\nKerkennah\nautrement',
                  textAlign: TextAlign.left,
                  style: AppFonts.playfair(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    height: 1.18,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Explorez un patrimoine\n'
                  'riche grâce à la réalité\n'
                  'augmentée et des contenus immersifs.',
                  textAlign: TextAlign.left,
                  style: AppFonts.dmSans(
                    fontSize: 15,
                    color: const Color(0xFF4A5560),
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                _Dots(index: 0, onTap: onDotTap),
                const SizedBox(height: 16),
                PrimaryButton(label: 'Suivant', onPressed: onNext),
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
    final size = MediaQuery.sizeOf(context);
    // Map stone QR plaque from source image (911×1920) through BoxFit.cover.
    final scanRect = _mapCoverRect(
      screen: size,
      imageSize: const Size(911, 1920),
      // Full plaque (QR + EcoAR mark), tuned from source pixels
      sourceRect: const Rect.fromLTWH(508, 772, 190, 248),
      pad: 0.04,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.bgOnboardingScan,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          gaplessPlayback: true,
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
        // AR corners locked to the QR plaque
        Positioned(
          left: scanRect.left,
          top: scanRect.top,
          width: scanRect.width,
          height: scanRect.height,
          child: const IgnorePointer(child: _ArScanCorners()),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 56),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          AppAssets.logo,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Passer',
                        style: AppFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Frosted glass bottom sheet (matches CEO mock)
              ClipRRect(
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
                        const _GoldCircleGlyph(
                          child: CustomPaint(painter: _QrScanIconPainter()),
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
                        _Dots(index: 1, onTap: onDotTap),
                        const SizedBox(height: 14),
                        PrimaryButton(label: 'Suivant', onPressed: onNext),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shared gold ring + soft gold wash used by onboarding feature icons.
class _GoldCircleGlyph extends StatelessWidget {
  const _GoldCircleGlyph({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.gold, width: 1.6),
      ),
      child: Center(
        child: SizedBox(width: 28, height: 28, child: child),
      ),
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

/// Gold QR + scan-corner glyph for the “Scannez…” card.
class _QrScanIconPainter extends CustomPainter {
  const _QrScanIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    final s = size.shortestSide;
    final inset = s * 0.06;
    final corner = s * 0.22;

    // Outer scan corners
    void cornerAt(double x, double y, bool right, bool bottom) {
      final path = Path();
      if (!right && !bottom) {
        path
          ..moveTo(x, y + corner)
          ..lineTo(x, y)
          ..lineTo(x + corner, y);
      } else if (right && !bottom) {
        path
          ..moveTo(x - corner, y)
          ..lineTo(x, y)
          ..lineTo(x, y + corner);
      } else if (!right && bottom) {
        path
          ..moveTo(x, y - corner)
          ..lineTo(x, y)
          ..lineTo(x + corner, y);
      } else {
        path
          ..moveTo(x - corner, y)
          ..lineTo(x, y)
          ..lineTo(x, y - corner);
      }
      canvas.drawPath(path, stroke);
    }

    cornerAt(inset, inset, false, false);
    cornerAt(s - inset, inset, true, false);
    cornerAt(inset, s - inset, false, true);
    cornerAt(s - inset, s - inset, true, true);

    // Mini QR finder squares
    void finder(Offset o, double box) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(o.dx, o.dy, box, box),
        Radius.circular(box * 0.12),
      );
      canvas.drawRRect(r, stroke);
      final inner = box * 0.38;
      final pad = (box - inner) / 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(o.dx + pad, o.dy + pad, inner, inner),
          Radius.circular(inner * 0.15),
        ),
        fill,
      );
    }

    final q = s * 0.22;
    final gap = s * 0.28;
    finder(Offset(gap, gap), q);
    finder(Offset(s - gap - q, gap), q);
    finder(Offset(gap, s - gap - q), q);

    // Small data modules
    final m = s * 0.07;
    final modules = <Offset>[
      Offset(s * 0.55, s * 0.55),
      Offset(s * 0.68, s * 0.55),
      Offset(s * 0.55, s * 0.68),
      Offset(s * 0.72, s * 0.72),
    ];
    for (final o in modules) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: o, width: m, height: m),
          Radius.circular(m * 0.2),
        ),
        fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        Image.asset(
          AppAssets.bgOnboardingHarbor,
          fit: BoxFit.cover,
          alignment: const Alignment(0, -0.08),
          gaplessPlayback: true,
        ),
        // Soft sky wash for navy headline readability
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Colors.white.withValues(alpha: 0.42),
                Colors.white.withValues(alpha: 0.12),
                Colors.transparent,
              ],
              stops: const [0.0, 0.32, 0.62],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 72),
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          AppAssets.logo,
                          height: 64,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    _SkipPill(onSkip: onSkip),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Text(
                      "Vivez l'histoire de\nKerkennah",
                      textAlign: TextAlign.center,
                      style: AppFonts.playfair(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Des parcours thématiques pour une découverte\n'
                      'immersive du patrimoine.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ClipPath(
                clipper: const _WaveTopClipper(),
                child: Container(
                  width: double.infinity,
                  color: AppColors.cream,
                  padding: EdgeInsets.fromLTRB(20, 40, 20, 20 + bottom),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ThemeFeatureIcon(
                            kind: _ThemeIconKind.patrimoine,
                            label: 'Patrimoine',
                          ),
                          _ThemeFeatureIcon(
                            kind: _ThemeIconKind.culture,
                            label: 'Culture',
                          ),
                          _ThemeFeatureIcon(
                            kind: _ThemeIconKind.traditions,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Soft wave along the top of the bottom sheet (CEO mock).
class _WaveTopClipper extends CustomClipper<Path> {
  const _WaveTopClipper();

  @override
  Path getClip(Size size) {
    final path = Path()..moveTo(0, 28);
    path.quadraticBezierTo(
      size.width * 0.25,
      8,
      size.width * 0.5,
      22,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      36,
      size.width,
      14,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

enum _ThemeIconKind { patrimoine, culture, traditions }

class _ThemeFeatureIcon extends StatelessWidget {
  const _ThemeFeatureIcon({
    required this.kind,
    required this.label,
  });

  final _ThemeIconKind kind;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GoldCircleGlyph(
          child: CustomPaint(painter: _ThemeIconPainter(kind)),
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

/// Gold line-art glyphs — same stroke language as [_QrScanIconPainter].
class _ThemeIconPainter extends CustomPainter {
  const _ThemeIconPainter(this.kind);

  final _ThemeIconKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.fill;

    final s = size.shortestSide;

    switch (kind) {
      case _ThemeIconKind.patrimoine:
        // Marabout dome + arched door (heritage site)
        final base = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.18, s * 0.58, s * 0.64, s * 0.28),
          Radius.circular(s * 0.04),
        );
        canvas.drawRRect(base, stroke);
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(s * 0.5, s * 0.58),
            width: s * 0.64,
            height: s * 0.55,
          ),
          math.pi,
          math.pi,
          false,
          stroke,
        );
        // Finial
        canvas.drawCircle(Offset(s * 0.5, s * 0.28), s * 0.035, fill);
        canvas.drawLine(
          Offset(s * 0.5, s * 0.28),
          Offset(s * 0.5, s * 0.34),
          stroke,
        );
        // Door arch
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(s * 0.5, s * 0.78),
            width: s * 0.22,
            height: s * 0.28,
          ),
          math.pi,
          math.pi,
          false,
          stroke,
        );
      case _ThemeIconKind.culture:
        // Amphora / ceramic vase
        final neck = RRect.fromRectAndRadius(
          Rect.fromLTWH(s * 0.38, s * 0.14, s * 0.24, s * 0.16),
          Radius.circular(s * 0.04),
        );
        canvas.drawRRect(neck, stroke);
        final body = Path()
          ..moveTo(s * 0.38, s * 0.30)
          ..quadraticBezierTo(s * 0.18, s * 0.48, s * 0.28, s * 0.72)
          ..quadraticBezierTo(s * 0.38, s * 0.88, s * 0.5, s * 0.88)
          ..quadraticBezierTo(s * 0.62, s * 0.88, s * 0.72, s * 0.72)
          ..quadraticBezierTo(s * 0.82, s * 0.48, s * 0.62, s * 0.30);
        canvas.drawPath(body, stroke);
        // Handles
        canvas.drawArc(
          Rect.fromCircle(center: Offset(s * 0.26, s * 0.42), radius: s * 0.11),
          -0.4,
          2.2,
          false,
          stroke,
        );
        canvas.drawArc(
          Rect.fromCircle(center: Offset(s * 0.74, s * 0.42), radius: s * 0.11),
          math.pi - 1.8,
          2.2,
          false,
          stroke,
        );
      case _ThemeIconKind.traditions:
        // Traditional fishing boat (matches harbor photo)
        canvas.drawLine(
          Offset(s * 0.46, s * 0.16),
          Offset(s * 0.46, s * 0.58),
          stroke,
        );
        final sail = Path()
          ..moveTo(s * 0.46, s * 0.18)
          ..lineTo(s * 0.76, s * 0.54)
          ..lineTo(s * 0.46, s * 0.54)
          ..close();
        canvas.drawPath(sail, stroke);
        final hull = Path()
          ..moveTo(s * 0.14, s * 0.64)
          ..lineTo(s * 0.86, s * 0.64)
          ..quadraticBezierTo(s * 0.78, s * 0.82, s * 0.58, s * 0.84)
          ..lineTo(s * 0.36, s * 0.84)
          ..quadraticBezierTo(s * 0.18, s * 0.82, s * 0.14, s * 0.64);
        canvas.drawPath(hull, stroke);
        // Soft wave
        final wave = Path()
          ..moveTo(s * 0.12, s * 0.90)
          ..quadraticBezierTo(s * 0.28, s * 0.84, s * 0.44, s * 0.90)
          ..quadraticBezierTo(s * 0.60, s * 0.96, s * 0.76, s * 0.90)
          ..quadraticBezierTo(s * 0.86, s * 0.86, s * 0.92, s * 0.90);
        canvas.drawPath(wave, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _ThemeIconPainter oldDelegate) =>
      oldDelegate.kind != kind;
}
