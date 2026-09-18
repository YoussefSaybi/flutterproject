import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

/// Gold EcoAR Kerkennah wordmark drawn in code (pin, arch, waves, dome, palm).
class EcoArWordmark extends StatelessWidget {
  const EcoArWordmark({
    super.key,
    this.width = 220,
    this.color = const Color(0xFFC9A24B),
  });

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final h = width * 0.72;
    return SizedBox(
      width: width,
      height: h,
      child: CustomPaint(
        painter: _EcoArWordmarkPainter(color: color),
        child: Column(
          children: [
            SizedBox(height: h * 0.22),
            Text(
              'EcoAR',
              textAlign: TextAlign.center,
              style: AppFonts.playfair(
                fontSize: width * 0.22,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1.0,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: h * 0.04),
              child: Text(
                'Kerkennah',
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.w500,
                  color: color,
                  letterSpacing: width * 0.028,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EcoArWordmarkPainter extends CustomPainter {
  _EcoArWordmarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.012
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final pinY = size.height * 0.02;
    final archR = size.width * 0.11;

    // --- Location pin ---
    final pinPath = Path();
    final pinTop = Offset(cx, pinY);
    pinPath.moveTo(pinTop.dx, pinTop.dy + archR * 0.95);
    pinPath.quadraticBezierTo(
      pinTop.dx - archR * 0.42,
      pinTop.dy + archR * 0.35,
      pinTop.dx - archR * 0.32,
      pinTop.dy + archR * 0.12,
    );
    pinPath.arcToPoint(
      Offset(pinTop.dx + archR * 0.32, pinTop.dy + archR * 0.12),
      radius: Radius.circular(archR * 0.34),
      clockwise: true,
    );
    pinPath.quadraticBezierTo(
      pinTop.dx + archR * 0.42,
      pinTop.dy + archR * 0.35,
      pinTop.dx,
      pinTop.dy + archR * 0.95,
    );
    canvas.drawPath(pinPath, fill);
    // Inner pin hole (cut look via darker stroke ring on gold fill)
    canvas.drawCircle(
      Offset(cx, pinY + archR * 0.22),
      archR * 0.1,
      Paint()
        ..color = color.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(cx, pinY + archR * 0.22),
      archR * 0.1,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.008,
    );

    // --- Arch under pin ---
    final archRect = Rect.fromCenter(
      center: Offset(cx, pinY + archR * 1.05),
      width: archR * 2.1,
      height: archR * 1.35,
    );
    canvas.drawArc(archRect, math.pi * 1.08, math.pi * 0.84, false, paint);

    // Side flourishes
    final flourishPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01
      ..strokeCap = StrokeCap.round;

    // Left flourish
    final lf = Path()
      ..moveTo(cx - archR * 1.35, pinY + archR * 0.95)
      ..quadraticBezierTo(
        cx - archR * 1.55,
        pinY + archR * 0.55,
        cx - archR * 1.2,
        pinY + archR * 0.35,
      );
    canvas.drawPath(lf, flourishPaint);
    // Right flourish
    final rf = Path()
      ..moveTo(cx + archR * 1.35, pinY + archR * 0.95)
      ..quadraticBezierTo(
        cx + archR * 1.55,
        pinY + archR * 0.55,
        cx + archR * 1.2,
        pinY + archR * 0.35,
      );
    canvas.drawPath(rf, flourishPaint);

    // --- Waves under EcoAR text ---
    final waveY = size.height * 0.58;
    final wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.014
      ..strokeCap = StrokeCap.round;

    Path wave(double y, double amp) {
      final p = Path();
      final startX = size.width * 0.12;
      final endX = size.width * 0.72;
      p.moveTo(startX, y);
      p.cubicTo(
        size.width * 0.28,
        y - amp,
        size.width * 0.42,
        y + amp,
        size.width * 0.55,
        y - amp * 0.35,
      );
      p.cubicTo(
        size.width * 0.62,
        y - amp * 0.7,
        size.width * 0.68,
        y + amp * 0.2,
        endX,
        y - amp * 0.15,
      );
      return p;
    }

    canvas.drawPath(wave(waveY, size.height * 0.028), wavePaint);
    canvas.drawPath(wave(waveY + size.height * 0.045, size.height * 0.022), wavePaint);
    canvas.drawPath(wave(waveY + size.height * 0.088, size.height * 0.016), wavePaint);

    // --- Dome building + palm (right of waves) ---
    final baseX = size.width * 0.76;
    final baseY = size.height * 0.68;
    final s = size.width * 0.055;

    // Building body
    final building = Path()
      ..moveTo(baseX - s * 0.7, baseY)
      ..lineTo(baseX - s * 0.7, baseY - s * 1.1)
      ..lineTo(baseX + s * 0.7, baseY - s * 1.1)
      ..lineTo(baseX + s * 0.7, baseY)
      ..close();
    canvas.drawPath(building, fill);

    // Dome
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(baseX, baseY - s * 1.1),
        width: s * 1.35,
        height: s * 1.1,
      ),
      math.pi,
      math.pi,
      true,
      fill,
    );
    // Dome finial
    canvas.drawCircle(Offset(baseX, baseY - s * 1.7), s * 0.12, fill);

    // Palm trunk
    final trunk = Path()
      ..moveTo(baseX + s * 1.15, baseY)
      ..quadraticBezierTo(
        baseX + s * 1.35,
        baseY - s * 1.2,
        baseX + s * 1.25,
        baseY - s * 2.2,
      );
    canvas.drawPath(
      trunk,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.01
        ..strokeCap = StrokeCap.round,
    );

    // Palm fronds
    final crown = Offset(baseX + s * 1.25, baseY - s * 2.2);
    for (var i = 0; i < 5; i++) {
      final angle = -math.pi * 0.85 + i * (math.pi * 0.35);
      final tip = Offset(
        crown.dx + math.cos(angle) * s * 1.1,
        crown.dy + math.sin(angle) * s * 0.85,
      );
      final mid = Offset(
        crown.dx + math.cos(angle) * s * 0.55,
        crown.dy + math.sin(angle) * s * 0.35 + s * 0.15,
      );
      final frond = Path()
        ..moveTo(crown.dx, crown.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, tip.dx, tip.dy);
      canvas.drawPath(
        frond,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.009
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EcoArWordmarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
