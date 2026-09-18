import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Signup full-screen background — 3 horizontal bands painted in code
/// (sky/sea, harbor+dome, rocky shore+boat). No photo JPGs.
class SignupCoastalBackground extends StatelessWidget {
  const SignupCoastalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(flex: 34, child: CustomPaint(painter: _SkySeaPainter())),
        Expanded(flex: 36, child: CustomPaint(painter: _HarborBandPainter())),
        Expanded(flex: 30, child: CustomPaint(painter: _ShoreBoatPainter())),
      ],
    );
  }
}

/// Band 1 — open sky + turquoise sea (like panel 1 / top of mockup).
class _SkySeaPainter extends CustomPainter {
  const _SkySeaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, h * 0.55),
          const [Color(0xFF4A9AD4), Color(0xFF8EC8EA), Color(0xFFD2EAF7)],
          const [0.0, 0.55, 1.0],
        ),
    );

    final seaTop = h * 0.52;
    canvas.drawRect(
      Rect.fromLTRB(0, seaTop, w, h),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, seaTop),
          Offset(0, h),
          const [Color(0xFF1E7AA8), Color(0xFF3BB5C9), Color(0xFF7AD4C8)],
          const [0.0, 0.45, 1.0],
        ),
    );

    // Horizon haze
    canvas.drawRect(
      Rect.fromLTRB(0, seaTop - 3, w, seaTop + 5),
      Paint()..color = const Color(0xFFB8D8E6).withValues(alpha: 0.55),
    );

    // Soft clouds
    final cloud = Paint()..color = Colors.white.withValues(alpha: 0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.25, h * 0.28), width: w * 0.35, height: h * 0.08),
      cloud,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.7, h * 0.2), width: w * 0.28, height: h * 0.06),
      cloud,
    );

    // Caustics
    final ripple = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    for (var i = 0; i < 5; i++) {
      final y = seaTop + h * (0.15 + i * 0.12);
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < w; x += 14) {
        path.quadraticBezierTo(x + 7, y + math.sin(x / 18 + i) * 3, x + 14, y);
      }
      canvas.drawPath(path, ripple);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Band 2 — harbor: palms, white dome building, small boat (signup_bg_top).
class _HarborBandPainter extends CustomPainter {
  const _HarborBandPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    // Sky remnant + sea
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, h),
          const [Color(0xFF7EBFDF), Color(0xFF2A96B8), Color(0xFF4EC4C0)],
          const [0.0, 0.35, 1.0],
        ),
    );

    // Distant water band
    canvas.drawRect(
      Rect.fromLTRB(0, h * 0.28, w, h),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.28),
          Offset(0, h),
          const [Color(0xFF1F7FA6), Color(0xFF3AB0C4), Color(0xFF6BCFC0)],
          const [0.0, 0.5, 1.0],
        ),
    );

    // Left palm
    _palm(canvas, Offset(w * 0.08, h * 0.15), h * 0.0024, 0.18);
    // Right palm by building
    _palm(canvas, Offset(w * 0.88, h * 0.2), h * 0.0022, -0.06);

    // Whitewashed buildings + dome (right)
    final white = Paint()..color = const Color(0xFFF7F4EE);
    final door = Paint()..color = const Color(0xFF2F6F9C);
    final bx = w * 0.55;
    final by = h * 0.22;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx, by + h * 0.08, w * 0.14, h * 0.28), const Radius.circular(2)),
      white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx + w * 0.12, by + h * 0.04, w * 0.2, h * 0.34), const Radius.circular(2)),
      white,
    );

    final domeCx = bx + w * 0.2;
    final domeCy = by + h * 0.02;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(domeCx, domeCy + h * 0.12), width: w * 0.16, height: h * 0.2),
      white,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(domeCx, domeCy), width: w * 0.16, height: h * 0.22),
      math.pi,
      math.pi,
      true,
      white,
    );
    canvas.drawCircle(Offset(domeCx, domeCy - h * 0.1), w * 0.012, white);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx + w * 0.04, by + h * 0.18, w * 0.035, h * 0.12), const Radius.circular(2)),
      door,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx + w * 0.16, by + h * 0.14, w * 0.04, h * 0.14), const Radius.circular(2)),
      door,
    );

    // Small boat on water
    _boat(canvas, Offset(w * 0.38, h * 0.72), w * 0.00115, blueTop: false);

    // Rocky shoreline bottom of band
    final rock = Paint()..color = const Color(0xFFD4C4A8);
    final shore = Path()
      ..moveTo(0, h)
      ..lineTo(0, h * 0.88)
      ..quadraticBezierTo(w * 0.2, h * 0.82, w * 0.4, h * 0.9)
      ..quadraticBezierTo(w * 0.7, h * 0.86, w, h * 0.92)
      ..lineTo(w, h)
      ..close();
    canvas.drawPath(shore, rock);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Band 3 — rocky shore + blue/white boat in clear water (signup_bg_bottom).
class _ShoreBoatPainter extends CustomPainter {
  const _ShoreBoatPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    // Clear turquoise water
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(0, h),
          const [Color(0xFF4EBFCB), Color(0xFF7AD8CF), Color(0xFFA8E4D4)],
          const [0.0, 0.45, 1.0],
        ),
    );

    // Seabed visible through water
    final bed = Paint()..color = const Color(0xFFC8B896).withValues(alpha: 0.35);
    for (var i = 0; i < 12; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * (0.1 + (i % 4) * 0.22), h * (0.55 + (i ~/ 4) * 0.15)),
          width: w * 0.12,
          height: h * 0.06,
        ),
        bed,
      );
    }

    // Stone jetty / rocky shore (left + bottom)
    final stone = Paint()..color = const Color(0xFFD9CBB0);
    final stoneDark = Paint()..color = const Color(0xFFB9A888);
    void block(Rect r) {
      canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)), stone);
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(3)),
        Paint()
          ..color = stoneDark.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    block(Rect.fromLTWH(0, h * 0.35, w * 0.22, h * 0.18));
    block(Rect.fromLTWH(w * 0.05, h * 0.5, w * 0.2, h * 0.16));
    block(Rect.fromLTWH(0, h * 0.62, w * 0.28, h * 0.2));
    block(Rect.fromLTWH(w * 0.15, h * 0.78, w * 0.25, h * 0.18));
    block(Rect.fromLTWH(w * 0.55, h * 0.7, w * 0.22, h * 0.16));
    block(Rect.fromLTWH(w * 0.72, h * 0.78, w * 0.28, h * 0.22));

    // Green plants on right rocks
    final leaf = Paint()
      ..color = const Color(0xFF2F6B3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      final p = Path()
        ..moveTo(w * 0.78 + i * 8, h * 0.72)
        ..quadraticBezierTo(w * 0.82 + i * 6, h * 0.55, w * 0.88 + i * 4, h * 0.42);
      canvas.drawPath(p, leaf);
    }

    // Blue/white rowboat (matching signup_bg_bottom)
    _boat(canvas, Offset(w * 0.48, h * 0.42), w * 0.00135, blueTop: true);

    // Rope
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.38, h * 0.44)
        ..quadraticBezierTo(w * 0.28, h * 0.55, w * 0.18, h * 0.62),
      Paint()
        ..color = const Color(0xFF5C4A32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void _palm(Canvas canvas, Offset base, double s, double lean) {
  canvas.save();
  canvas.translate(base.dx, base.dy);
  canvas.rotate(lean);
  final trunk = Path()
    ..moveTo(0, 0)
    ..quadraticBezierTo(10 * s * 50, -45 * s * 50, 4 * s * 50, -120 * s * 50);
  canvas.drawPath(
    trunk,
    Paint()
      ..color = const Color(0xFF8A6A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(3.0, 5.5 * s * 50)
      ..strokeCap = StrokeCap.round,
  );
  final crown = Offset(4 * s * 50, -120 * s * 50);
  final leaf = Paint()
    ..color = const Color(0xFF2F7A3E)
    ..style = PaintingStyle.stroke
    ..strokeWidth = math.max(2.0, 3.2 * s * 50)
    ..strokeCap = StrokeCap.round;
  for (var i = 0; i < 8; i++) {
    final a = -math.pi * 0.95 + i * (math.pi * 0.25);
    final tip = Offset(crown.dx + math.cos(a) * 65 * s * 50, crown.dy + math.sin(a) * 48 * s * 50);
    final mid = Offset(crown.dx + math.cos(a) * 32 * s * 50, crown.dy + math.sin(a) * 20 * s * 50 + 8 * s * 50);
    canvas.drawPath(
      Path()
        ..moveTo(crown.dx, crown.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, tip.dx, tip.dy),
      leaf,
    );
  }
  canvas.restore();
}

void _boat(Canvas canvas, Offset c, double scale, {required bool blueTop}) {
  canvas.save();
  canvas.translate(c.dx, c.dy);
  final s = scale * 110;
  final hull = Path()
    ..moveTo(-32 * s, 2 * s)
    ..quadraticBezierTo(-8 * s, 12 * s, 26 * s, 5 * s)
    ..quadraticBezierTo(34 * s, 0, 28 * s, -6 * s)
    ..lineTo(-26 * s, -8 * s)
    ..close();

  if (blueTop) {
    canvas.drawPath(hull, Paint()..color = const Color(0xFFF5F2EB));
    // Blue upper stripe on the boat
    canvas.drawPath(
      Path()
        ..moveTo(-28 * s, -7 * s)
        ..lineTo(27 * s, -5 * s)
        ..lineTo(26 * s, -1 * s)
        ..lineTo(-28 * s, -2 * s)
        ..close(),
      Paint()..color = const Color(0xFF2E7BB0),
    );
  } else {
    canvas.drawPath(hull, Paint()..color = const Color(0xFFF5F2EB));
    canvas.drawPath(
      hull,
      Paint()
        ..color = const Color(0xFF2B6B9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, 2.2 * s),
    );
  }

  canvas.drawLine(
    Offset(-14 * s, 0),
    Offset(16 * s, 1 * s),
    Paint()
      ..color = const Color(0xFF8B5A2B)
      ..strokeWidth = math.max(1.0, 1.4 * s),
  );
  canvas.restore();
}
