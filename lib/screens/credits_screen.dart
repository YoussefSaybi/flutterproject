import 'dart:ui';

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
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardScale;
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

    _cardOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.32, 0.68, curve: Curves.easeOut),
    );
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
      ),
    );
    _cardScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    _footerOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.58, 0.95, curve: Curves.easeOut),
    );
    _footerSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.58, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _glowPulse = Tween<double>(begin: 0.38, end: 0.55).animate(
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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.32),
                  ],
                  stops: const [0, 0.42, 1],
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
                        padding: EdgeInsets.fromLTRB(24, 16, 24, 52 + bottom),
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
                              SizedBox(height: h * 0.12),
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
                                            width: 200,
                                            height: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(90),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withValues(
                                                    alpha: _glowPulse.value,
                                                  ),
                                                  blurRadius: 48,
                                                  spreadRadius: 14,
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
                              const Spacer(),
                              FadeTransition(
                                opacity: _cardOpacity,
                                child: SlideTransition(
                                  position: _cardSlide,
                                  child: ScaleTransition(
                                    scale: _cardScale,
                                    child: const _PartnersGlassCard(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              FadeTransition(
                                opacity: _footerOpacity,
                                child: SlideTransition(
                                  position: _footerSlide,
                                  child: Column(
                                    children: [
                                      const _GoldLeafDivider(),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Application développée dans le cadre du projet SAWN,\n'
                                        'avec le soutien du Fonds Équipe France et du ministère\n'
                                        'de l\'Europe et des Affaires étrangères.',
                                        textAlign: TextAlign.center,
                                        style: AppFonts.dmSans(
                                          color: Colors.white,
                                          fontSize: 11,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
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

class _PartnersGlassCard extends StatefulWidget {
  const _PartnersGlassCard();

  @override
  State<_PartnersGlassCard> createState() => _PartnersGlassCardState();
}

class _PartnersGlassCardState extends State<_PartnersGlassCard>
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
      final start = 0.15 + i * 0.18;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });
    _logoScales = List.generate(3, (i) {
      final start = 0.15 + i * 0.18;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.82, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerCtrl,
          curve: Interval(start, end, curve: Curves.easeOutBack),
        ),
      );
    });

    // Start after the glass card begins its own entrance.
    Future<void>.delayed(const Duration(milliseconds: 480), () {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFB8D4E0).withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.65),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FadeTransition(
                    opacity: _logoOpacities[0],
                    child: ScaleTransition(
                      scale: _logoScales[0],
                      child: const _LogoCell(
                        asset: AppAssets.logoAmbassade,
                        height: 68,
                        label: 'Ambassade de France en Tunisie',
                      ),
                    ),
                  ),
                ),
                _GoldVDivider(),
                Expanded(
                  child: FadeTransition(
                    opacity: _logoOpacities[1],
                    child: ScaleTransition(
                      scale: _logoScales[1],
                      child: const _LogoCell(
                        asset: AppAssets.logoInstitutFrancais,
                        height: 56,
                        label: 'Institut Français Tunisie',
                      ),
                    ),
                  ),
                ),
                _GoldVDivider(),
                Expanded(
                  child: FadeTransition(
                    opacity: _logoOpacities[2],
                    child: ScaleTransition(
                      scale: _logoScales[2],
                      child: const _LogoCell(
                        asset: AppAssets.logoSawn,
                        height: 72,
                        label: 'SAWN',
                      ),
                    ),
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Center(
          child: Image.asset(
            asset,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Text(
              label,
              textAlign: TextAlign.center,
              style: AppFonts.dmSans(fontSize: 9, color: AppColors.navy),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoldVDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: 1,
        color: AppColors.gold.withValues(alpha: 0.7),
      ),
    );
  }
}

class _GoldLeafDivider extends StatelessWidget {
  const _GoldLeafDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.2,
            color: AppColors.gold.withValues(alpha: 0.85),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Icon(Icons.eco_rounded, size: 20, color: AppColors.gold),
        ),
        Expanded(
          child: Container(
            height: 1.2,
            color: AppColors.gold.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
