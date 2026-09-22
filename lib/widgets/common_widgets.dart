import 'package:flutter/material.dart';

import '../l10n/locale_controller.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

class EcoLogo extends StatelessWidget {
  const EcoLogo({
    super.key,
    this.color = AppColors.gold,
    this.compact = false,
    this.showSubtitle = true,
    this.height,
  });

  final Color color;
  final bool compact;
  final bool showSubtitle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final h = height ?? (compact ? 48.0 : 72.0);
    return Image.asset(
      AppAssets.logo,
      height: h,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined, color: color, size: compact ? 18 : 22),
          Text(
            'EcoAR',
            style: AppFonts.playfair(
              color: color,
              fontSize: compact ? 22 : 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showSubtitle)
            Text(
              'Kerkennah',
              style: AppFonts.dmSans(
                color: color,
                fontSize: compact ? 11 : 13,
                letterSpacing: 2.2,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

/// Méliès production logo — shared PNG asset (not styled text).
class MeliesLogo extends StatelessWidget {
  const MeliesLogo({super.key, this.height = 36, this.color = AppColors.gold});

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logoMelies,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        'Méliès',
        style: AppFonts.greatVibes(color: color, fontSize: height * 0.85),
      ),
    );
  }
}

class PackIcon extends StatelessWidget {
  const PackIcon(
    this.asset, {
    super.key,
    this.size = 28,
    this.color,
  });

  final String asset;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.image_not_supported_outlined, size: size),
    );
  }
}

/// Soft rounded white chevron — thin stroke, matches CTA fleche reference.
class SoftChevronIcon extends StatelessWidget {
  const SoftChevronIcon({
    super.key,
    this.size = 18,
    this.color = Colors.white,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SoftChevronPainter(color: color),
      ),
    );
  }
}

class _SoftChevronPainter extends CustomPainter {
  const _SoftChevronPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    // Thin stroke like the reference fleche
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = (s * 0.095).clamp(1.6, 2.2)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Classic > shape — open ~90°, not too wide
    final path = Path()
      ..moveTo(s * 0.36, s * 0.22)
      ..lineTo(s * 0.64, s * 0.50)
      ..lineTo(s * 0.36, s * 0.78);

    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _SoftChevronPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Primary pill CTA — centered label + thin fleche on the right (CEO reference).
/// Press: soft shrink + fleche slides. Idle: gentle fleche nudge.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.chevron_right_rounded,
    this.backgroundColor = AppColors.navy,
    this.foregroundColor = AppColors.white,
    this.expand = true,
    this.enabled = true,
    this.showTrailing = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expand;
  final bool enabled;
  final bool showTrailing;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with TickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
    reverseDuration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1, end: 0.96)
      .animate(CurvedAnimation(
    parent: _press,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutBack,
  ));
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);
  late final Animation<double> _idleSlide = Tween<double>(begin: 0, end: 4)
      .animate(CurvedAnimation(parent: _idle, curve: Curves.easeInOut));
  late final Animation<double> _pressSlide = Tween<double>(begin: 0, end: 3)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _press.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep multi-word labels on one line (e.g. "Se connecter").
    final singleLineLabel = widget.label.replaceAll(' ', '\u00A0');
    final useSoftChevron = widget.showTrailing &&
        (widget.icon == null ||
            widget.icon == Icons.chevron_right_rounded ||
            widget.icon == Icons.arrow_forward_rounded);

    final fleche = !widget.showTrailing
        ? const SizedBox.shrink()
        : AnimatedBuilder(
            animation: Listenable.merge([_idle, _press]),
            builder: (_, __) => Transform.translate(
              offset: Offset(_idleSlide.value + _pressSlide.value, 0),
              child: useSoftChevron
                  ? SoftChevronIcon(
                      size: 18,
                      color: widget.foregroundColor,
                    )
                  : Icon(
                      widget.icon,
                      size: 18,
                      color: widget.foregroundColor,
                    ),
            ),
          );

    // Stack keeps label optically centered; fleche sits on the right edge.
    final content = SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              singleLineLabel,
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: widget.foregroundColor,
                height: 1.2,
              ),
            ),
          ),
          if (widget.showTrailing)
            Positioned(
              right: 18,
              child: fleche,
            ),
        ],
      ),
    );

    final child = AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: Material(
        color: widget.enabled
            ? widget.backgroundColor
            : widget.backgroundColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppLayout.radiusPill),
        child: InkWell(
          onTap: widget.enabled ? widget.onPressed : null,
          onHighlightChanged: (v) {
            if (!widget.enabled) return;
            if (v) {
              _press.forward();
            } else {
              _press.reverse();
            }
          },
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          splashColor: widget.foregroundColor.withValues(alpha: 0.14),
          highlightColor: widget.foregroundColor.withValues(alpha: 0.08),
          child: content,
        ),
      ),
    );

    return widget.expand
        ? SizedBox(width: double.infinity, child: child)
        : child;
  }
}

/// Secondary outlined pill (Google / Apple style).
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: const StadiumBorder(),
          backgroundColor: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Text(
              label,
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pattern A sheet — top-rounded cream/white card with soft overlap shadow.
class SheetCard extends StatelessWidget {
  const SheetCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(24, 28, 24, 24),
    this.color = AppColors.cream,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppLayout.radiusSheet),
        ),
        boxShadow: AppLayout.sheetShadow,
      ),
      padding: padding,
      child: child,
    );
  }
}

/// Winding path mark for Parcours (matches brand icon — not Material alt_route).
class ParcoursPathIcon extends StatelessWidget {
  const ParcoursPathIcon({
    super.key,
    this.size = 24,
    this.color = AppColors.gold,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ParcoursPathPainter(color),
      ),
    );
  }
}

class _ParcoursPathPainter extends CustomPainter {
  const _ParcoursPathPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Match Material outlined icons (~1.8px at 22) — thin hairline stroke.
    final stroke = (size.shortestSide * 0.082).clamp(1.4, 2.0);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;
    // Horizontal S / switchback with outlined circular terminals.
    final start = Offset(w * 0.16, h * 0.76);
    final end = Offset(w * 0.84, h * 0.24);
    final r = size.shortestSide * 0.11;

    final path = Path()
      ..moveTo(start.dx + r * 0.55, start.dy)
      ..lineTo(w * 0.70, h * 0.76)
      ..cubicTo(w * 0.90, h * 0.76, w * 0.90, h * 0.50, w * 0.70, h * 0.50)
      ..lineTo(w * 0.30, h * 0.50)
      ..cubicTo(w * 0.10, h * 0.50, w * 0.10, h * 0.24, w * 0.30, h * 0.24)
      ..lineTo(end.dx - r * 0.55, end.dy);

    canvas.drawPath(path, paint);
    canvas.drawCircle(start, r, paint);
    canvas.drawCircle(end, r, paint);
  }

  @override
  bool shouldRepaint(covariant _ParcoursPathPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Teal backdrop with palm-leaf shadows on both top corners (Profil style).
class PalmLeafBackdrop extends StatelessWidget {
  const PalmLeafBackdrop({super.key});

  static Widget _leaf({
    required Alignment alignment,
    bool mirror = false,
  }) {
    Widget img = Image.asset(
      AppAssets.bgProfileHeader,
      fit: BoxFit.cover,
      alignment: alignment,
      errorBuilder: (_, __, ___) => const SizedBox.expand(),
    );
    if (mirror) {
      img = Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1, 1, 1),
        child: img,
      );
    }
    return img;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFF005664)),
        // Left palm fronds
        _leaf(alignment: const Alignment(-0.95, -1.0)),
        // Mirrored palm fronds on the right
        _leaf(alignment: const Alignment(-0.95, -1.0), mirror: true),
      ],
    );
  }
}

/// Shared Accueil-style header: palm-leaf shadow background + centered gold logo.
class PalmLeafHeader extends StatelessWidget {
  const PalmLeafHeader({
    super.key,
    this.height,
    this.logoHeight = 78,
    this.child,
  });

  /// Total header height including status bar. Defaults to `top + 112`.
  final double? height;
  final double logoHeight;
  /// Optional overlay (e.g. title) drawn above the palm background.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final headerH = height ?? (top + 112.0);

    return SizedBox(
      height: headerH,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const PalmLeafBackdrop(),
          Padding(
            padding: EdgeInsets.only(top: top + 8, bottom: 14),
            child: Center(
              child: Image.asset(
                AppAssets.logoGold,
                height: logoHeight,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Text(
                  'EcoAR',
                  style: AppFonts.playfair(
                    fontSize: logoHeight * 0.36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}

/// Teal app header for Pattern B (logo + language or back/settings).
class TealHeader extends StatelessWidget {
  const TealHeader({
    super.key,
    this.showBack = false,
    this.onBack,
    this.trailing,
    this.showLanguage = false,
    this.logoHeight = 40,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool showLanguage;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.navy,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 14),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                child: showBack
                    ? SoftCircleButton(
                        onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                        icon: Icons.chevron_left_rounded,
                        background: AppColors.white.withValues(alpha: 0.15),
                        foreground: AppColors.white,
                        size: 40,
                      )
                    : null,
              ),
              Expanded(
                child: Center(child: EcoLogo(compact: true, height: logoHeight)),
              ),
              if (trailing != null)
                trailing!
              else if (showLanguage)
                const LanguageSwitcher(darkBackground: true)
              else
                const SizedBox(width: 44),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({
    super.key,
    this.selected,
    this.onChanged,
    this.useComponent = true,
    this.darkBackground = true,
  });

  final String? selected;
  final ValueChanged<String>? onChanged;
  final bool useComponent;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        const langs = ['AR', 'FR', 'EN', 'ES', 'DE', 'PT', 'TR'];
        final current = selected ?? LocaleController.instance.code;
        final inactive = darkBackground
            ? AppColors.white.withValues(alpha: 0.85)
            : AppColors.navy;
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: darkBackground
                ? AppColors.white.withValues(alpha: 0.15)
                : AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: darkBackground
                ? null
                : Border.all(color: AppColors.navy.withValues(alpha: 0.18)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: langs.map((lang) {
              final active = lang == current;
              return GestureDetector(
                onTap: () {
                  LocaleController.instance.setCode(lang);
                  onChanged?.call(lang);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? AppColors.gold : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    lang,
                    style: AppFonts.dmSans(
                      color: active ? AppColors.navy : inactive,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.hint = 'Rechercher un lieu, un parcours...',
    this.onTap,
    this.usePackImage = false,
  });

  final String hint;
  final VoidCallback? onTap;
  final bool usePackImage;

  @override
  Widget build(BuildContext context) {
    return _fallbackField();
  }

  Widget _fallbackField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppLayout.radiusPill),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        readOnly: onTap != null,
        onTap: onTap,
        style: AppFonts.dmSans(color: AppColors.navy),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppFonts.dmSans(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.primaryTeal.withValues(alpha: 0.75),
            size: 24,
          ),
          suffixIcon: Icon(
            Icons.tune_rounded,
            color: AppColors.primaryTeal.withValues(alpha: 0.75),
            size: 22,
          ),
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppLayout.radiusPill),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppLayout.radiusPill),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppLayout.radiusPill),
            borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class SoftCircleButton extends StatefulWidget {
  const SoftCircleButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.asset,
    this.background = AppColors.white,
    this.foreground = AppColors.navy,
    this.size = 42,
  });

  final IconData? icon;
  final String? asset;
  final VoidCallback onPressed;
  final Color background;
  final Color foreground;
  final double size;

  @override
  State<SoftCircleButton> createState() => _SoftCircleButtonState();
}

class _SoftCircleButtonState extends State<SoftCircleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 180),
  );

  late final Animation<double> _btnScale = Tween<double>(begin: 1, end: 0.90)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  // Icon pops + rotates slightly while pressed.
  late final Animation<double> _iconScale = Tween<double>(begin: 1, end: 1.22)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));
  late final Animation<double> _iconTurn = Tween<double>(begin: 0, end: 0.06)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.size * 0.45;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _press.forward(),
      onTapCancel: () => _press.reverse(),
      onTapUp: (_) async {
        await _press.reverse();
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, _) {
          final t = _press.value;
          final press = 1 - _btnScale.value;
          final iconColor = Color.lerp(
            widget.foreground,
            AppColors.gold,
            t * 0.85,
          )!;
          return Transform.scale(
            scale: _btnScale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10 + press * 0.06),
                    blurRadius: 10 + press * 6,
                    offset: Offset(0, 3 + press * 2),
                  ),
                ],
              ),
              child: Center(
                child: Transform.rotate(
                  angle: _iconTurn.value * 3.14159,
                  child: Transform.scale(
                    scale: _iconScale.value,
                    child: widget.asset != null
                        ? PackIcon(
                            widget.asset!,
                            size: widget.size * 0.55,
                            color: iconColor,
                          )
                        : Icon(
                            widget.icon ?? Icons.circle,
                            color: iconColor,
                            size: iconSize,
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class PackImage extends StatelessWidget {
  const PackImage(
    this.asset, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String asset;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final img = Image.asset(
      asset,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: AppColors.creamDark,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: AppColors.textSecondary),
      ),
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}

class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    required this.count,
    required this.index,
    this.onTap,
  });

  final int count;
  final int index;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(i) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: active ? 9 : 8,
            height: active ? 9 : 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? AppColors.gold : const Color(0xFFD0D5D8),
            ),
          ),
        );
      }),
    );
  }
}
