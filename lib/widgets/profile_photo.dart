import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Renders a profile photo from a local file path or falls back to [placeholder].
class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.path,
    required this.size,
    this.placeholder,
  });

  final String? path;
  final double size;
  final Widget? placeholder;

  bool get _isFile {
    final p = path;
    if (p == null || p.isEmpty) return false;
    if (p.startsWith('assets/')) return false;
    try {
      return File(p).existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fallback = placeholder ??
        ColoredBox(
          color: const Color(0xFFD8E3E8),
          child: Center(
            child: Icon(
              Icons.person_rounded,
              size: size * 0.5,
              color: AppColors.navy.withValues(alpha: 0.45),
            ),
          ),
        );

    if (!_isFile) return SizedBox(width: size, height: size, child: fallback);

    return SizedBox(
      width: size,
      height: size,
      child: Image.file(
        File(path!),
        key: ValueKey(path),
        fit: BoxFit.cover,
        width: size,
        height: size,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}
