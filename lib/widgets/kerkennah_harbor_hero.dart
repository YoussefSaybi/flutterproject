import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Kerkennah coastal hero — painted in code (no photo asset).
class KerkennahHarborHero extends StatelessWidget {
  const KerkennahHarborHero({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        if (size.isEmpty) return const SizedBox.expand();
        return CustomPaint(
          size: size,
          painter: _HarborPainter(),
        );
      },
    );
  }
}

class _HarborPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    // Sky
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, h * 0.45),
          const [Color(0xFF5BA3D9), Color(0xFF9ECDED), Color(0xFFD7EEF8)],
          const [0.0, 0.5, 1.0],
        ),
    );

    // Sea
    final seaTop = h * 0.36;
    canvas.drawRect(
      Rect.fromLTRB(0, seaTop, w, h),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, seaTop),
          Offset(0, h),
          const [
            Color(0xFF186A9A),
            Color(0xFF2A9BB8),
            Color(0xFF4DBFCB),
            Color(0xFF7DD4C8),
          ],
          const [0.0, 0.3, 0.65, 1.0],
        ),
    );

    // Horizon haze
    canvas.drawRect(
      Rect.fromLTRB(0, seaTop - 4, w, seaTop + 6),
      Paint()..color = const Color(0xFFAED0DE).withValues(alpha: 0.55),
    );

    // Ripples
    final ripple = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (var i = 0; i < 8; i++) {
      final y = seaTop + h * (0.1 + i * 0.075);
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < w; x += 16) {
        path.quadraticBezierTo(
          x + 8,
          y + math.sin((x / 20) + i) * 3.5,
          x + 16,
          y,
        );
      }
      canvas.drawPath(path, ripple);
    }

    // Rocky shore
    final rockFill = Paint()..color = const Color(0xFFD9CBB0);
    final rockEdge = Paint()
      ..color = const Color(0xFFB9A888)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    void rock(List<Offset> pts) {
      final p = Path()..addPolygon(pts, true);
      canvas.drawPath(p, rockFill);
      canvas.drawPath(p, rockEdge);
    }

    rock([
      Offset(0, h),
      Offset(0, h * 0.88),
      Offset(w * 0.16, h * 0.84),
      Offset(w * 0.28, h * 0.92),
      Offset(w * 0.34, h),
    ]);
    rock([
      Offset(w * 0.55, h),
      Offset(w * 0.58, h * 0.9),
      Offset(w * 0.78, h * 0.86),
      Offset(w, h * 0.9),
      Offset(w, h),
    ]);

    // Village + dome (right)
    final white = Paint()..color = const Color(0xFFF8F5EF);
    final door = Paint()..color = const Color(0xFF2F6F9C);
    final bx = w * 0.58;
    final by = seaTop + h * 0.04;

    canvas.drawRect(Rect.fromLTWH(bx, by + h * 0.04, w * 0.14, h * 0.18), white);
    canvas.drawRect(Rect.fromLTWH(bx + w * 0.12, by, w * 0.22, h * 0.22), white);

    final domeCx = bx + w * 0.2;
    final domeCy = by;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(domeCx, domeCy + h * 0.06), width: w * 0.16, height: h * 0.12),
      white,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(domeCx, domeCy), width: w * 0.16, height: h * 0.14),
      math.pi,
      math.pi,
      true,
      white,
    );
    canvas.drawCircle(Offset(domeCx, domeCy - h * 0.07), w * 0.012, white);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx + w * 0.04, by + h * 0.1, w * 0.035, h * 0.08),
        const Radius.circular(2),
      ),
      door,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bx + w * 0.16, by + h * 0.08, w * 0.04, h * 0.09),
        const Radius.circular(2),
      ),
      door,
    );

    // Palms
    _palm(canvas, Offset(w * 0.1, h * 0.2), h * 0.0018, 0.12);
    _palm(canvas, Offset(w * 0.9, seaTop), h * 0.0022, -0.05);

    // Overhang fronds (left)
    final frond = Paint()
      ..color = const Color(0xFF2D6B3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 6; i++) {
      final p = Path()
        ..moveTo(-10, h * (0.01 + i * 0.012))
        ..quadraticBezierTo(w * 0.2, h * (0.1 + i * 0.025), w * 0.38, h * (0.22 + i * 0.035));
      canvas.drawPath(p, frond);
    }

    // Boats
    _boat(canvas, Offset(w * 0.3, h * 0.62), w * 0.0012);
    _boat(canvas, Offset(w * 0.48, h * 0.7), w * 0.001, flip: true);
    _boat(canvas, Offset(w * 0.64, h * 0.58), w * 0.00085);
  }

  void _palm(Canvas canvas, Offset base, double s, double lean) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.rotate(lean);
    final trunk = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(12 * s * 50, -50 * s * 50, 6 * s * 50, -130 * s * 50);
    canvas.drawPath(
      trunk,
      Paint()
        ..color = const Color(0xFF8A6A2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(3.0, 6 * s * 50)
        ..strokeCap = StrokeCap.round,
    );
    final crown = Offset(6 * s * 50, -130 * s * 50);
    final leaf = Paint()
      ..color = const Color(0xFF2F7A3E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, 3.5 * s * 50)
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 8; i++) {
      final a = -math.pi * 0.95 + i * (math.pi * 0.25);
      final tip = Offset(crown.dx + math.cos(a) * 70 * s * 50, crown.dy + math.sin(a) * 50 * s * 50);
      final mid = Offset(crown.dx + math.cos(a) * 35 * s * 50, crown.dy + math.sin(a) * 22 * s * 50 + 10 * s * 50);
      canvas.drawPath(
        Path()
          ..moveTo(crown.dx, crown.dy)
          ..quadraticBezierTo(mid.dx, mid.dy, tip.dx, tip.dy),
        leaf,
      );
    }
    canvas.restore();
  }

  void _boat(Canvas canvas, Offset c, double scale, {bool flip = false}) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    if (flip) canvas.scale(-1, 1);
    final s = scale * 110;
    final hull = Path()
      ..moveTo(-30 * s, 0)
      ..quadraticBezierTo(-8 * s, 11 * s, 24 * s, 5 * s)
      ..quadraticBezierTo(32 * s, 0, 28 * s, -5 * s)
      ..lineTo(-24 * s, -7 * s)
      ..close();
    canvas.drawPath(hull, Paint()..color = const Color(0xFFF5F2EB));
    canvas.drawPath(
      hull,
      Paint()
        ..color = const Color(0xFF2B6B9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, 2.4 * s),
    );
    canvas.drawLine(
      Offset(-16 * s, -2 * s),
      Offset(16 * s, 0),
      Paint()
        ..color = const Color(0xFFC45A3A)
        ..strokeWidth = math.max(1.0, 1.3 * s),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
