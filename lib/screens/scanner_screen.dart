import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';
import '../widgets/onboarding_micro_interactions.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  /// Asset size of [AppAssets.bgScanner].
  static const _imgSize = Size(576, 1024);

  /// QR plaque region in normalized image coords (0–1), with light padding.
  static const _qrNorm = Rect.fromLTRB(0.400, 0.348, 0.658, 0.498);

  /// Maps a normalized image rect to screen coords under BoxFit.cover.
  static Rect _coverMappedRect(Size viewport, Rect norm) {
    final s = (viewport.width / _imgSize.width) >
            (viewport.height / _imgSize.height)
        ? viewport.width / _imgSize.width
        : viewport.height / _imgSize.height;
    final dispW = _imgSize.width * s;
    final dispH = _imgSize.height * s;
    final dx = (viewport.width - dispW) / 2;
    final dy = (viewport.height - dispH) / 2;
    return Rect.fromLTRB(
      dx + norm.left * dispW,
      dy + norm.top * dispH,
      dx + norm.right * dispW,
      dy + norm.bottom * dispH,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = Size(constraints.maxWidth, constraints.maxHeight);
          final qrRect = _coverMappedRect(viewport, _qrNorm);
          // Keep frame square around the QR.
          final side = qrRect.shortestSide * 1.08;
          final frame = Rect.fromCenter(
            center: qrRect.center,
            width: side,
            height: side,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(AppAssets.bgScanner, fit: BoxFit.cover),
              Container(color: Colors.black.withValues(alpha: 0.18)),

              // White corner brackets locked onto the QR — pulse + scan sweep.
              Positioned(
                left: frame.left,
                top: frame.top,
                width: frame.width,
                height: frame.height,
                child: const IgnorePointer(
                  child: PulsingScanFrame(
                    child: CustomPaint(painter: _BracketPainter()),
                  ),
                ),
              ),

              Column(
                children: [
                  const PalmLeafHeader(),
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 36),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(
                                  AppLayout.radiusPill,
                                ),
                                boxShadow: AppLayout.softShadow,
                              ),
                              child: Text(
                                'Scanner un point patrimonial',
                                textAlign: TextAlign.center,
                                style: AppFonts.playfair(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Placez le QR code dans le cadre pour accéder à son histoire.',
                                textAlign: TextAlign.center,
                                style: AppFonts.dmSans(
                                  color: AppColors.white,
                                  height: 1.4,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SheetCard(
                            color: AppColors.white,
                            padding:
                                const EdgeInsets.fromLTRB(18, 10, 18, 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: AppColors.border,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(
                                        AppAssets.bg08,
                                        width: 78,
                                        height: 104,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const PackIcon(
                                                AppAssets.iconLandmarkGold,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Savoir-faire',
                                                style: AppFonts.dmSans(
                                                  color: AppColors.gold,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  letterSpacing: 0.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Atelier de charfiya',
                                            style: AppFonts.playfair(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Découvrez l\'art de la charfiya, émail et tradition transmis de génération en génération.',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppFonts.dmSans(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                              height: 1.35,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          PrimaryButton(
                                            label: 'Découvrir',
                                            onPressed: () =>
                                                AppNav.openAr(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
            ],
          );
        },
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final arm = (size.shortestSide * 0.22).clamp(26.0, 48.0);
    final r = (size.shortestSide * 0.08).clamp(10.0, 16.0);

    void corner(Offset origin, double sx, double sy) {
      final path = Path()
        ..moveTo(origin.dx + sx * arm, origin.dy)
        ..lineTo(origin.dx + sx * r, origin.dy)
        ..quadraticBezierTo(
          origin.dx,
          origin.dy,
          origin.dx,
          origin.dy + sy * r,
        )
        ..lineTo(origin.dx, origin.dy + sy * arm);
      canvas.drawPath(path, paint);
    }

    corner(Offset.zero, 1, 1);
    corner(Offset(size.width, 0), -1, 1);
    corner(Offset(0, size.height), 1, -1);
    corner(Offset(size.width, size.height), -1, -1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
