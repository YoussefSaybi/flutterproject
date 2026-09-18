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
                width: double.infinity,
                color: AppColors.navy,
                padding: EdgeInsets.fromLTRB(8, top + 6, 8, 12),
                child: Row(
                  children: [
                    SoftCircleButton(
                      icon: Icons.close_rounded,
                      background: AppColors.white.withValues(alpha: 0.15),
                      foreground: AppColors.white,
                      size: 40,
                      onPressed: () => AppNav.goHome(context),
                    ),
                    const Expanded(
                      child: Center(child: EcoLogo(compact: true, height: 40)),
                    ),
                    SoftCircleButton(
                      icon: Icons.flash_on_rounded,
                      background: AppColors.white.withValues(alpha: 0.15),
                      foreground: AppColors.white,
                      size: 40,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 36),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppLayout.radiusPill),
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
                          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                        const Spacer(),
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CustomPaint(painter: _BracketPainter()),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: SheetCard(
                        color: AppColors.white,
                        padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
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
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const l = 40.0;
    canvas.drawLine(Offset.zero, const Offset(l, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, l), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - l, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, l), paint);
    canvas.drawLine(Offset(0, size.height), Offset(l, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - l), paint);
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - l, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - l),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
