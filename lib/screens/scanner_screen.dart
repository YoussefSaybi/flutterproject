import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgVillage, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.28)),
          Column(
            children: [
              Container(
                color: AppColors.navy,
                padding: EdgeInsets.fromLTRB(8, top + 6, 8, 12),
                child: Row(
                  children: [
                    SoftCircleButton(
                      icon: Icons.close,
                      onPressed: () => AppNav.goHome(context),
                    ),
                    const Expanded(child: EcoLogo(compact: true, height: 40)),
                    SoftCircleButton(
                      icon: Icons.flash_on_rounded,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 36),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Placez le QR code dans le cadre pour accéder à son histoire.',
                  textAlign: TextAlign.center,
                  style: AppFonts.dmSans(color: AppColors.white, height: 1.4),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 220,
                height: 220,
                child: CustomPaint(painter: _BracketPainter()),
              ),
              const Spacer(),
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 12 + bottom),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        AppAssets.bg08,
                        width: 72,
                        height: 96,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const PackIcon(AppAssets.iconLandmarkGold, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'Savoir-faire',
                                style: AppFonts.dmSans(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
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
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          PrimaryButton(
                            label: 'Découvrir',
                            onPressed: () => AppNav.openAr(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 40.0;
    canvas.drawLine(Offset.zero, const Offset(l, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, l), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - l, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, l), paint);
    canvas.drawLine(Offset(0, size.height), Offset(l, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - l), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - l, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - l), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
