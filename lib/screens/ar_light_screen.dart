import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ArLightScreen extends StatelessWidget {
  const ArLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.navyDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgCharfiya, fit: BoxFit.cover),
          Positioned(
            top: top + 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                SoftCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  background: Colors.black.withValues(alpha: 0.4),
                  foreground: AppColors.white,
                  size: 42,
                  onPressed: () => AppNav.popOr(context, '/scanner'),
                ),
                const Expanded(
                  child: Center(child: EcoLogo(compact: true, height: 40)),
                ),
                SoftCircleButton(
                  icon: Icons.menu_rounded,
                  background: Colors.black.withValues(alpha: 0.4),
                  foreground: AppColors.white,
                  size: 42,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(alpha: 0.45),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                Container(
                  width: 1.5,
                  height: 56,
                  color: AppColors.gold.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 108 + bottom,
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 14, 14, 18),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.58),
                borderRadius: BorderRadius.circular(AppLayout.radiusCard),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Charfiya traditionnelle',
                          style: AppFonts.playfair(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SoftCircleButton(
                        icon: Icons.close_rounded,
                        background: Colors.white.withValues(alpha: 0.12),
                        foreground: AppColors.white,
                        size: 34,
                        onPressed: () =>
                            AppNav.popOr(context, '/scanner'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Embarcation emblématique de Kerkennah, utilisée par les pêcheurs depuis des générations.',
                    style: AppFonts.dmSans(
                      color: Colors.white70,
                      height: 1.4,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _Tag(label: 'Patrimoine maritime'),
                      _Tag(label: 'Savoir-faire local'),
                      _Tag(label: 'Île Chergui'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: "Écouter l'histoire",
                    icon: Icons.volume_up_rounded,
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.navy,
                    onPressed: () => AppNav.openAudio(context),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 18 + bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ArNavButton(
                  icon: Icons.map_outlined,
                  label: 'Carte',
                  onTap: () => AppNav.goMap(context),
                ),
                _ArNavButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scanner',
                  large: true,
                  onTap: () => AppNav.popOr(context, '/scanner'),
                ),
                _ArNavButton(
                  icon: Icons.favorite_rounded,
                  label: 'Favoris',
                  onTap: () => AppNav.openFavorites(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppLayout.radiusPill),
      ),
      child: Text(
        label,
        style: AppFonts.dmSans(
          color: AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// AR bottom chrome — SoftCircleButton press motion (white icons).
class _ArNavButton extends StatefulWidget {
  const _ArNavButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool large;

  @override
  State<_ArNavButton> createState() => _ArNavButtonState();
}

class _ArNavButtonState extends State<_ArNavButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 180),
  );

  late final Animation<double> _btnScale = Tween<double>(begin: 1, end: 0.90)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  late final Animation<double> _iconScale = Tween<double>(begin: 1, end: 1.22)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  late final Animation<double> _iconTurn = Tween<double>(begin: 0, end: 0.06)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _press.reverse();
    if (!mounted) return;
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.large ? 64.0 : 50.0;
    final iconSize = widget.large ? 28.0 : 22.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _press.forward(),
      onTapCancel: () => _press.reverse(),
      onTapUp: (_) => _handleTap(),
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, _) {
          final press = 1 - _btnScale.value;

          return Transform.scale(
            scale: _btnScale.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.navy.withValues(
                      alpha: widget.large ? 0.92 : 0.78,
                    ),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.22),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.28 + press * 0.08,
                        ),
                        blurRadius: 12 + press * 6,
                        offset: Offset(0, 4 + press * 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: _iconTurn.value * 3.14159,
                      child: Transform.scale(
                        scale: _iconScale.value,
                        child: Icon(
                          widget.icon,
                          color: AppColors.white,
                          size: iconSize,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.label,
                  style: AppFonts.dmSans(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

