import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/app_session.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Crédits / Partenaires — flashscreen (auto-advance, no Continuer).
/// Launch flow: Splash → Credits → Onboarding (Découvrir Kerkennah).
/// Layout matches CEO reference: open photo, floating partner logos, leaf under copy.
class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key, this.fromMenu = false});

  final bool fromMenu;

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen>
    with TickerProviderStateMixin {
  static const _displayMin = Duration(milliseconds: 4200);
  static const _fadeOut = Duration(milliseconds: 320);
  static const _introDur = Duration(milliseconds: 1600);

  bool _navigated = false;
  late final AnimationController _fadeCtrl;
  late final AnimationController _introCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _fade;

  late final Animation<double> _bgOpacity;
  late final Animation<double> _bgScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _partnersOpacity;
  late final Animation<Offset> _partnersSlide;
  late final Animation<double> _footerOpacity;
  late final Animation<Offset> _footerSlide;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: _fadeOut, value: 1);
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    _introCtrl = AnimationController(vsync: this, duration: _introDur);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _bgOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _bgScale = Tween<double>(begin: 1.06, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.08, 0.42, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.08, 0.48, curve: Curves.easeOutBack),
      ),
    );

    _partnersOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.36, 0.72, curve: Curves.easeOut),
    );
    _partnersSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.36, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _footerOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.58, 0.95, curve: Curves.easeOut),
    );
    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.58, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.28, end: 0.42).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _introCtrl.forward();
      _glowCtrl.repeat(reverse: true);
      if (!widget.fromMenu) _autoAdvance();
    });
  }

  Future<void> _autoAdvance() async {
    await Future<void>.delayed(_displayMin);
    await _goNext();
  }

  Future<void> _goNext() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    _glowCtrl.stop();
    await AppSession.instance.completeCredits();
    await _fadeCtrl.reverse();
    if (!mounted) return;
    context.go(AppSession.instance.routeAfterCredits());
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _introCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottom = media.padding.bottom;
    final h = media.size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF7EB8C9),
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: _bgOpacity,
              child: ScaleTransition(
                scale: _bgScale,
                child: Image.asset(
                  AppAssets.bgSplash,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  gaplessPlayback: true,
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Color(0xFF7EB8C9)),
                ),
              ),
            ),
            // Soft top wash for gold logo; light bottom lift for white copy only
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.38),
                  ],
                  stops: const [0, 0.28, 0.58, 1],
                ),
              ),
            ),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 12, 20, 10 + bottom),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              if (widget.fromMenu)
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: SoftCircleButton(
                                    icon: Icons.arrow_back_rounded,
                                    background: AppColors.white
                                        .withValues(alpha: 0.9),
                                    onPressed: () =>
                                        AppNav.popOr(context, '/profile'),
                                  ),
                                ),
                              SizedBox(height: h * 0.10),
                              FadeTransition(
                                opacity: _logoOpacity,
                                child: ScaleTransition(
                                  scale: _logoScale,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AnimatedBuilder(
                                        animation: _glowPulse,
                                        builder: (context, child) {
                                          return Container(
                                            width: 190,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withValues(
                                                    alpha: _glowPulse.value,
                                                  ),
                                                  blurRadius: 40,
                                                  spreadRadius: 10,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const EcoLogo(height: 108),
                                    ],
                                  ),
                                ),
                              ),
                              // Open middle — photo stays the hero (CEO mock)
                              const Spacer(),
                              FadeTransition(
                                opacity: _partnersOpacity,
                                child: SlideTransition(
                                  position: _partnersSlide,
                                  child: const _PartnersRow(),
                                ),
                              ),
                              const SizedBox(height: 14),
                              FadeTransition(
                                opacity: _footerOpacity,
                                child: SlideTransition(
                                  position: _footerSlide,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Application développée dans le cadre du projet SAWN,\n'
                                        'avec le soutien du Fonds Équipe France et du ministère\n'
                                        'de l\'Europe et des Affaires étrangères.',
                                        textAlign: TextAlign.center,
                                        style: AppFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          height: 1.45,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                        ).copyWith(
                                          shadows: const [
                                            Shadow(
                                              color: Color(0x66000000),
                                              blurRadius: 8,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      const _MeliesWordmark(),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Méliès mark flanked by short gold rules (left / right).
class _MeliesWordmark extends StatelessWidget {
  const _MeliesWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _MeliesRule(),
        SizedBox(width: 12),
        MeliesLogo(height: 32),
        SizedBox(width: 12),
        _MeliesRule(),
      ],
    );
  }
}

class _MeliesRule extends StatelessWidget {
  const _MeliesRule();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0.15),
            AppColors.gold.withValues(alpha: 0.95),
            AppColors.gold.withValues(alpha: 0.15),
          ],
        ),
      ),
    );
  }
}

/// Partner marks float on the photo — no glass card (matches reference).
class _PartnersRow extends StatefulWidget {
  const _PartnersRow();

  @override
  State<_PartnersRow> createState() => _PartnersRowState();
}

class _PartnersRowState extends State<_PartnersRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerCtrl;
  late final List<Animation<double>> _logoOpacities;
  late final List<Animation<double>> _logoScales;

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoOpacities = List.generate(3, (i) {
      final start = 0.1 + i * 0.16;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });
    _logoScales = List.generate(3, (i) {
      final start = 0.1 + i * 0.16;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.86, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    Future<void>.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _staggerCtrl.forward();
    });
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget logo(int i, Widget child) {
      return Expanded(
        child: FadeTransition(
          opacity: _logoOpacities[i],
          child: ScaleTransition(
            scale: _logoScales[i],
            child: child,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 88,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            logo(
              0,
              const _LogoCell(
                asset: AppAssets.logoAmbassade,
                height: 78,
                label: 'Ambassade de France en Tunisie',
              ),
            ),
            const _PartnerDivider(),
            logo(
              1,
              const _LogoCell(
                asset: AppAssets.logoInstitutFrancais,
                height: 64,
                label: 'Institut Français Tunisie',
              ),
            ),
            const _PartnerDivider(),
            logo(
              2,
              const _LogoCell(
                asset: AppAssets.logoSawn,
                height: 80,
                label: 'SAWN',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thin vertical rule between partner marks (CEO partenaires mock).
class _PartnerDivider extends StatelessWidget {
  const _PartnerDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      child: Container(
        width: 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gold.withValues(alpha: 0.2),
              AppColors.gold.withValues(alpha: 0.95),
              AppColors.gold.withValues(alpha: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoCell extends StatelessWidget {
  const _LogoCell({
    required this.asset,
    required this.height,
    required this.label,
  });

  final String asset;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Center(
          child: Image.asset(
            asset,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              label,
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(fontSize: 9, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
