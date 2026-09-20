import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import 'auth_micro_interactions.dart';

/// Fade + rise + soft scale when a page becomes active.
class OnboardingEntrance extends StatefulWidget {
  const OnboardingEntrance({
    super.key,
    required this.active,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 22,
    this.scaleFrom = 0.94,
  });

  final bool active;
  final Widget child;
  final Duration delay;
  final double offset;
  final double scaleFrom;

  @override
  State<OnboardingEntrance> createState() => _OnboardingEntranceState();
}

class _OnboardingEntranceState extends State<OnboardingEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 640),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.7, curve: Curves.easeOut),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: Offset(0, widget.offset / 100),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
  late final Animation<double> _scale = Tween<double>(
    begin: widget.scaleFrom,
    end: 1,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    if (widget.active) _play();
  }

  @override
  void didUpdateWidget(covariant OnboardingEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _play();
  }

  Future<void> _play() async {
    _c.value = 0;
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
      if (!mounted || !widget.active) return;
    }
    await _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

/// Slow cinematic zoom / drift on hero photography.
/// Animation values match the original Ken Burns; a fixed overscan
/// prevents cream/white gaps at the screen edges during pan.
class KenBurnsBackground extends StatefulWidget {
  const KenBurnsBackground({
    super.key,
    required this.asset,
    required this.active,
    this.alignment = Alignment.center,
  });

  final String asset;
  final bool active;
  final Alignment alignment;

  @override
  State<KenBurnsBackground> createState() => _KenBurnsBackgroundState();
}

class _KenBurnsBackgroundState extends State<KenBurnsBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant KenBurnsBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _c.repeat(reverse: true);
    } else if (!widget.active && oldWidget.active) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final t = Curves.easeInOut.transform(_c.value);
          // Original Ken Burns motion
          final scale = 1.0 + (0.08 * t);
          final dx = (t - 0.5) * 0.04;
          final dy = (0.5 - t) * 0.03;
          final size = MediaQuery.sizeOf(context);
          return Transform.scale(
            // Fixed overscan only — does not alter the animation curve
            scale: 1.12,
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(dx * size.width, dy * size.height),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: Image.asset(
                  widget.asset,
                  fit: BoxFit.cover,
                  alignment: widget.alignment,
                  gaplessPlayback: true,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Soft vertical float for the brand mark.
class FloatingLogo extends StatefulWidget {
  const FloatingLogo({
    super.key,
    required this.child,
    required this.active,
  });

  final Widget child;
  final bool active;

  @override
  State<FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<FloatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2800),
  );
  late final Animation<double> _y = Tween<double>(begin: -4, end: 4).animate(
    CurvedAnimation(parent: _c, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant FloatingLogo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _c.repeat(reverse: true);
    } else if (!widget.active && oldWidget.active) {
      _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _y,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _y.value), child: child),
      child: widget.child,
    );
  }
}

/// Gold feature / scan glyph with press bounce, glow ring, optional pulse.
class AnimatedGoldGlyph extends StatefulWidget {
  const AnimatedGoldGlyph({
    super.key,
    required this.child,
    this.onTap,
    this.pulse = false,
    this.size = 58,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool pulse;
  final double size;

  @override
  State<AnimatedGoldGlyph> createState() => _AnimatedGoldGlyphState();
}

class _AnimatedGoldGlyphState extends State<AnimatedGoldGlyph>
    with TickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _pressScale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 0.86), weight: 30),
    TweenSequenceItem(tween: Tween(begin: 0.86, end: 1.12), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1), weight: 30),
  ]).animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );
  late final Animation<double> _pulseScale =
      Tween<double>(begin: 1, end: 1.07).animate(
    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
  );
  late final Animation<double> _glow =
      Tween<double>(begin: 0.18, end: 0.42).animate(
    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulse) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant AnimatedGoldGlyph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse != oldWidget.pulse) {
      if (widget.pulse) {
        _pulse.repeat(reverse: true);
      } else {
        _pulse
          ..stop()
          ..value = 0;
      }
    }
  }

  @override
  void dispose() {
    _press.dispose();
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _press.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([_press, _pulse]),
        builder: (_, __) {
          final scale =
              _pressScale.value * (widget.pulse ? _pulseScale.value : 1.0);
          final glow = widget.pulse ? _glow.value : 0.2;
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.gold, width: 1.6),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: glow),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: SizedBox(width: 28, height: 28, child: widget.child),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Page dots — active stretches into a gold pill with soft glow.
class OnboardingDots extends StatelessWidget {
  const OnboardingDots({
    super.key,
    required this.index,
    required this.onTap,
    this.inactiveColor = const Color(0xFFD0D5D8),
  });

  final int index;
  final ValueChanged<int> onTap;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == index;
        return PressableScale(
          scale: 0.86,
          onTap: () => onTap(i),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutBack,
              width: active ? 26 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: active ? AppColors.gold : inactiveColor,
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.45),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Soft press feedback for Passer / skip controls.
class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({
    super.key,
    required this.onSkip,
    this.outlined = false,
  });

  final VoidCallback onSkip;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      'Passer',
      style: AppFonts.dmSans(
        fontWeight: FontWeight.w600,
        fontSize: outlined ? 13 : 15,
        color: AppColors.white,
      ),
    );

    return PressableScale(
      scale: 0.94,
      onTap: onSkip,
      child: outlined
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
              child: label,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: label,
            ),
    );
  }
}

/// Gentle breathing pulse for AR scan corners + sweeping highlight line.
class PulsingScanFrame extends StatefulWidget {
  const PulsingScanFrame({
    super.key,
    required this.child,
    this.active = true,
  });

  final Widget child;
  final bool active;

  @override
  State<PulsingScanFrame> createState() => _PulsingScanFrameState();
}

class _PulsingScanFrameState extends State<PulsingScanFrame>
    with TickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  late final Animation<double> _opacity =
      Tween<double>(begin: 0.5, end: 1).animate(
    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
  );
  late final Animation<double> _scale =
      Tween<double>(begin: 0.96, end: 1.03).animate(
    CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(covariant PulsingScanFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) {
      _start();
    } else if (!widget.active && oldWidget.active) {
      _pulse.stop();
      _sweep.stop();
    }
  }

  void _start() {
    _pulse.repeat(reverse: true);
    _sweep.repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: Listenable.merge([_pulse, _sweep]),
          builder: (_, child) {
            final y = constraints.maxHeight * _sweep.value;
            return Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _scale.value,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    child!,
                    Positioned(
                      left: 4,
                      right: 4,
                      top: (y - 7).clamp(0.0, constraints.maxHeight),
                      height: 14,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.65),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Parallax shift based on PageView scroll progress.
class ParallaxShift extends StatelessWidget {
  const ParallaxShift({
    super.key,
    required this.pageDelta,
    required this.child,
    this.factor = 28,
  });

  /// How far this page is from being fully selected (−1…1).
  final double pageDelta;
  final Widget child;
  final double factor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-pageDelta * factor, 0),
      child: child,
    );
  }
}

/// Soft frosted lift for bottom sheets on appear.
class GlassSheetReveal extends StatelessWidget {
  const GlassSheetReveal({
    super.key,
    required this.active,
    required this.child,
  });

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return OnboardingEntrance(
      active: active,
      delay: const Duration(milliseconds: 100),
      offset: 36,
      scaleFrom: 0.97,
      child: child,
    );
  }
}
