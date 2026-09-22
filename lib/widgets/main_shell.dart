import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_assets.dart';
import '../theme/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = navigationShell.currentIndex;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 0,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFE8E6E0), width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  _NavItem(
                    asset: AppAssets.navAccueil,
                    assetActive: AppAssets.navAccueilActive,
                    selected: index == 0,
                    onTap: () => _onTap(0),
                  ),
                  _NavItem(
                    asset: AppAssets.navCarte,
                    assetActive: AppAssets.navCarteActive,
                    selected: index == 1,
                    onTap: () => _onTap(1),
                  ),
                  _NavItem(
                    asset: AppAssets.navParcours,
                    assetActive: AppAssets.navParcoursActive,
                    selected: index == 2,
                    onTap: () => _onTap(2),
                  ),
                  _NavItem(
                    asset: AppAssets.navScanner,
                    assetActive: AppAssets.navScannerActive,
                    selected: index == 3,
                    onTap: () => _onTap(3),
                  ),
                  _NavItem(
                    asset: AppAssets.navProfil,
                    assetActive: AppAssets.navProfilActive,
                    selected: index == 4,
                    onTap: () => _onTap(4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.asset,
    required this.assetActive,
    required this.selected,
    required this.onTap,
  });

  final String asset;
  final String assetActive;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  late final AnimationController _press;
  late final AnimationController _select;
  late final AnimationController _breathe;

  late final Animation<double> _pressScale;
  late final Animation<double> _selectScale;
  late final Animation<double> _selectLift;
  late final Animation<double> _glow;
  late final Animation<double> _breatheScale;

  @override
  void initState() {
    super.initState();

    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _pressScale = Tween<double>(begin: 1, end: 0.88).animate(
      CurvedAnimation(parent: _press, curve: Curves.easeOutCubic),
    );

    _select = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _selectScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.16), weight: 38),
      TweenSequenceItem(tween: Tween(begin: 1.16, end: 0.96), weight: 28),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.05), weight: 34),
    ]).animate(CurvedAnimation(parent: _select, curve: Curves.easeOutCubic));

    _selectLift = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -3.5), weight: 40),
      TweenSequenceItem(tween: Tween(begin: -3.5, end: -1.5), weight: 60),
    ]).animate(CurvedAnimation(parent: _select, curve: Curves.easeOutCubic));

    _glow = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.28), weight: 45),
      TweenSequenceItem(tween: Tween(begin: 0.28, end: 0.16), weight: 55),
    ]).animate(CurvedAnimation(parent: _select, curve: Curves.easeOut));

    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _breatheScale = Tween<double>(begin: 1, end: 1.04).animate(
      CurvedAnimation(parent: _breathe, curve: Curves.easeInOut),
    );

    if (widget.selected) {
      _select.value = 1;
      _breathe.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected == oldWidget.selected) return;

    if (widget.selected) {
      _select.forward(from: 0);
      _breathe.repeat(reverse: true);
    } else {
      _select.reverse();
      _breathe
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _press.dispose();
    _select.dispose();
    _breathe.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _press.forward(),
        onTapCancel: () => _press.reverse(),
        onTapUp: (_) {
          _press.reverse();
          _handleTap();
        },
        child: AnimatedBuilder(
          animation: Listenable.merge([_press, _select, _breathe]),
          builder: (context, _) {
            final baseScale = widget.selected
                ? (_select.isAnimating
                    ? _selectScale.value
                    : 1.05 * _breatheScale.value)
                : (_select.isAnimating || _select.value > 0
                    ? Tween<double>(begin: 1, end: 1.05)
                        .transform(_select.value)
                    : 1.0);
            final scale = baseScale * _pressScale.value;
            final lift = widget.selected || _select.isAnimating
                ? _selectLift.value
                : 0.0;
            final glow = widget.selected || _select.isAnimating
                ? _glow.value
                : 0.0;

            return Center(
              child: Transform.translate(
                offset: Offset(0, lift),
                child: Transform.scale(
                  scale: scale,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      if (glow > 0.01)
                        Container(
                          width: 42,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withValues(alpha: glow),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, anim) {
                          return FadeTransition(
                            opacity: anim,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.88, end: 1)
                                  .animate(anim),
                              child: child,
                            ),
                          );
                        },
                        child: Image.asset(
                          widget.selected ? widget.assetActive : widget.asset,
                          key: ValueKey(
                            widget.selected
                                ? widget.assetActive
                                : widget.asset,
                          ),
                          height: 34,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, __, ___) =>
                              const SizedBox(height: 34),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
