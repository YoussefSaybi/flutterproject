import 'package:flutter/material.dart';

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
      errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported_outlined, size: size),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
    this.backgroundColor = AppColors.navy,
    this.foregroundColor = AppColors.white,
    this.expand = true,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool expand;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final child = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        disabledBackgroundColor: backgroundColor.withValues(alpha: 0.4),
        disabledForegroundColor: foregroundColor.withValues(alpha: 0.7),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (expand) const Spacer(flex: 1),
          Text(
            label,
            style: AppFonts.dmSans(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: foregroundColor,
            ),
          ),
          if (expand) const Spacer(flex: 1),
          if (icon != null) Icon(icon, size: 18),
        ],
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({
    super.key,
    this.selected = 'FR',
    this.onChanged,
    this.useComponent = true,
    this.darkBackground = true,
  });

  final String selected;
  final ValueChanged<String>? onChanged;
  final bool useComponent;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    // Interactive language pills — darkBackground:false for cream/light headers.
    const langs = ['AR', 'FR', 'EN'];
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
          final active = lang == selected;
          return GestureDetector(
            onTap: () => onChanged?.call(lang),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: active ? AppColors.gold : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                lang,
                style: AppFonts.dmSans(
                  color: active ? AppColors.white : inactive,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }).toList(),
      ),
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
    if (usePackImage) {
      return GestureDetector(
        onTap: onTap,
        child: Image.asset(
          AppAssets.searchBar,
          fit: BoxFit.fitWidth,
          width: double.infinity,
          errorBuilder: (_, __, ___) => _fallbackField(),
        ),
      );
    }
    return _fallbackField();
  }

  Widget _fallbackField() {
    return TextField(
      readOnly: onTap != null,
      onTap: onTap,
      style: AppFonts.dmSans(color: AppColors.navy),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(color: AppColors.textSecondary.withValues(alpha: 0.75)),
        prefixIcon: const PackIcon(AppAssets.iconSearch, size: 22),
        suffixIcon: const PackIcon(AppAssets.iconFilter, size: 22),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.2),
        ),
      ),
    );
  }
}

class SoftCircleButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: asset != null
                ? PackIcon(asset!, size: size * 0.55)
                : Icon(icon ?? Icons.circle, color: foreground, size: size * 0.45),
          ),
        ),
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
