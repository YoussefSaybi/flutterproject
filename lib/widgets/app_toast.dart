import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';

enum AppToastKind { success, error, info }

/// Floating EcoAR toast — soft card, colored accent rail, clear icon hierarchy.
class AppToast {
  AppToast._();

  static const green = Color(0xFF2F7A4B);
  static const greenDeep = Color(0xFF1F5A36);
  static const greenMist = Color(0xFFEDF7F0);

  static void success(BuildContext context, String message) =>
      show(context, message, kind: AppToastKind.success);

  static void error(BuildContext context, String message) =>
      show(context, message, kind: AppToastKind.error);

  static void info(BuildContext context, String message) =>
      show(context, message, kind: AppToastKind.info);

  static void show(
    BuildContext context,
    String message, {
    AppToastKind kind = AppToastKind.info,
    Duration duration = const Duration(milliseconds: 2600),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
        content: _ToastCard(message: message, kind: kind),
      ),
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.message, required this.kind});

  final String message;
  final AppToastKind kind;

  IconData get _icon => switch (kind) {
        AppToastKind.success => Icons.check_rounded,
        AppToastKind.error => Icons.close_rounded,
        AppToastKind.info => Icons.info_rounded,
      };

  Color get _accent => switch (kind) {
        AppToastKind.success => AppToast.green,
        AppToastKind.error => const Color(0xFFA33A3A),
        AppToastKind.info => const Color(0xFF175B68),
      };

  Color get _surface => switch (kind) {
        AppToastKind.success => AppToast.greenMist,
        AppToastKind.error => const Color(0xFFF9EEEE),
        AppToastKind.info => const Color(0xFFEEF5F6),
      };

  String get _label => switch (kind) {
        AppToastKind.success => 'Succès',
        AppToastKind.error => 'Erreur',
        AppToastKind.info => 'Info',
      };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _accent.withValues(alpha: 0.22)),
          boxShadow: [
            BoxShadow(
              color: _accent.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accent rail
              Container(
                width: 5,
                color: _accent,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _accent,
                              Color.lerp(_accent, Colors.black, 0.18)!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(_icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _label,
                              style: AppFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: _accent,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              message,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF123F4A),
                                height: 1.30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
