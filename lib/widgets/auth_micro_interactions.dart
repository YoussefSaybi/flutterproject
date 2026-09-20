import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';
import 'common_widgets.dart';

const _navy = Color(0xFF1B4A5A);

/// Springy press scale for any tappable surface.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.scale = 0.96,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 220),
  );
  late final Animation<double> _scale = Tween<double>(
    begin: 1,
    end: widget.scale,
  ).animate(CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.elasticOut,
  ));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _down(TapDownDetails _) {
    if (!widget.enabled) return;
    _c.forward();
  }

  void _up([_]) {
    if (!widget.enabled) return;
    _c.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: widget.enabled ? (_) => _c.forward() : null,
      onPointerUp: widget.enabled ? (_) => _c.reverse() : null,
      onPointerCancel: widget.enabled ? (_) => _c.reverse() : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.enabled ? widget.onTap : null,
        onTapDown: _down,
        onTapUp: _up,
        onTapCancel: _up,
        child: ScaleTransition(scale: _scale, child: widget.child),
      ),
    );
  }
}

/// Primary navy stadium CTA — press scale + sliding chevron.
class AuthPrimaryButton extends StatefulWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.height = 54,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;

  @override
  State<AuthPrimaryButton> createState() => _AuthPrimaryButtonState();
}

class _AuthPrimaryButtonState extends State<AuthPrimaryButton>
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
  late final Animation<double> _idleSlide = Tween<double>(begin: 0, end: 5)
      .animate(CurvedAnimation(parent: _idle, curve: Curves.easeInOut));
  late final Animation<double> _chevron = Tween<double>(begin: 0, end: 4)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));
  late final Animation<double> _chevronPop = Tween<double>(begin: 1, end: 1.15)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  bool get _enabled => widget.onPressed != null && !widget.loading;

  @override
  void dispose() {
    _press.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _press,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: child,
        );
      },
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _enabled ? widget.onPressed : null,
            onHighlightChanged: (v) {
              if (!_enabled) return;
              if (v) {
                _press.forward();
              } else {
                _press.reverse();
              }
            },
            borderRadius: BorderRadius.circular(999),
            splashColor: Colors.white.withValues(alpha: 0.14),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Ink(
              decoration: BoxDecoration(
                color: _enabled
                    ? _navy
                    : _navy.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: widget.loading
                    ? const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          const Spacer(),
                          Text(
                            widget.label,
                            style: AppFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          AnimatedBuilder(
                            animation: Listenable.merge([_idle, _press]),
                            builder: (_, __) => Transform.translate(
                              offset: Offset(
                                _idleSlide.value + _chevron.value,
                                0,
                              ),
                              child: Transform.scale(
                                scale: _chevronPop.value,
                                child: const SoftChevronIcon(size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined social pill — press scale + soft leading pop.
class AuthSocialButton extends StatefulWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  State<AuthSocialButton> createState() => _AuthSocialButtonState();
}

class _AuthSocialButtonState extends State<AuthSocialButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    reverseDuration: const Duration(milliseconds: 280),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1, end: 0.97)
      .animate(CurvedAnimation(
    parent: _press,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.elasticOut,
  ));
  late final Animation<double> _icon = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 1.14), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.14, end: 1), weight: 60),
  ]).animate(CurvedAnimation(parent: _press, curve: Curves.easeOutBack));

  bool get _enabled => widget.onPressed != null;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _press,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: Material(
          color: Colors.white,
          shape: StadiumBorder(
            side: BorderSide(color: _navy.withValues(alpha: 0.14)),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _enabled ? widget.onPressed : null,
            onHighlightChanged: (v) {
              if (!_enabled) return;
              if (v) {
                _press.forward(from: 0);
              } else {
                _press.reverse();
              }
            },
            splashColor: _navy.withValues(alpha: 0.06),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(scale: _icon, child: widget.leading),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Prefix / action icon that reacts to focus or press.
class AuthAnimatedIcon extends StatefulWidget {
  const AuthAnimatedIcon({
    super.key,
    required this.icon,
    this.focused = false,
    this.size = 22,
    this.color,
    this.activeColor = _navy,
  });

  final IconData icon;
  final bool focused;
  final double size;
  final Color? color;
  final Color activeColor;

  @override
  State<AuthAnimatedIcon> createState() => _AuthAnimatedIconState();
}

class _AuthAnimatedIconState extends State<AuthAnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void initState() {
    super.initState();
    if (widget.focused) _c.value = 1;
  }

  @override
  void didUpdateWidget(covariant AuthAnimatedIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focused != oldWidget.focused) {
      if (widget.focused) {
        _c.forward();
      } else {
        _c.reverse();
      }
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idle = widget.color ?? _navy.withValues(alpha: 0.5);
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeOutBack.transform(_c.value);
        return Transform.scale(
          scale: 1 + (0.12 * t),
          child: Icon(
            widget.icon,
            size: widget.size,
            color: Color.lerp(idle, widget.activeColor, t),
          ),
        );
      },
    );
  }
}

/// Icon button with bounce on tap (visibility, etc.).
class AuthBounceIconButton extends StatefulWidget {
  const AuthBounceIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  @override
  State<AuthBounceIconButton> createState() => _AuthBounceIconButtonState();
}

class _AuthBounceIconButtonState extends State<AuthBounceIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 1, end: 0.82), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 0.82, end: 1.12), weight: 35),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1), weight: 30),
  ]).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    await _c.forward(from: 0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final btn = IconButton(
      tooltip: widget.tooltip,
      onPressed: _tap,
      icon: ScaleTransition(
        scale: _scale,
        child: Icon(
          widget.icon,
          color: widget.color ?? _navy.withValues(alpha: 0.45),
          size: 22,
        ),
      ),
    );
    return btn;
  }
}

/// Underline text link with soft press dim + scale.
class AuthTextLink extends StatefulWidget {
  const AuthTextLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<AuthTextLink> createState() => _AuthTextLinkState();
}

class _AuthTextLinkState extends State<AuthTextLink>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _opacity =
      Tween<double>(begin: 1, end: 0.55).animate(_c);
  late final Animation<double> _scale =
      Tween<double>(begin: 1, end: 0.97).animate(_c);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap();
      },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Text(
              widget.label,
              style: AppFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Checkbox with scale pop when toggled.
class AuthAnimatedCheckbox extends StatelessWidget {
  const AuthAnimatedCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: value ? 1.08 : 1),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: _navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
