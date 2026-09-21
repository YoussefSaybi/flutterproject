import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../services/app_session.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// CEO splash — same motion language as [CreditsScreen] for a continuous flash.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _brandMin = Duration(milliseconds: 4200);
  static const _hardCap = Duration(milliseconds: 5500);
  /// Match partenaires fade-out.
  static const _fadeOut = Duration(milliseconds: 320);
  /// Match partenaires intro duration.
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
  late final Animation<double> _tagOpacity;
  late final Animation<Offset> _tagSlide;
  late final Animation<double> _tagScale;
  late final Animation<double> _meliesOpacity;
  late final Animation<Offset> _meliesSlide;
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

    // Same bg settle as partenaires
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

    // Same logo entrance as partenaires
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

    // Tagline = same motion as partners glass card
    _tagOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.32, 0.68, curve: Curves.easeOut),
    );
    _tagSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
      ),
    );
    _tagScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _introCtrl,
        curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
      ),
    );

    // Méliès = same motion as partenaires footer
    _meliesOpacity = CurvedAnimation(
      parent: _introCtrl,
      curve: const Interval(0.58, 0.95, curve: Curves.easeOut),
    );
    _meliesSlide = Tween<Offset>(
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      _bootstrapAndLeave();
    });
  }

  Future<void> _bootstrapAndLeave() async {
    final bootstrap = _bootstrap();
    final branding = Future<void>.delayed(_brandMin);
    await Future.any<void>([
      Future.wait<void>([bootstrap, branding]),
      Future<void>.delayed(_hardCap),
    ]);
    await _leave();
  }

  Future<void> _bootstrap() async {
    await AppSession.instance.init();
    if (!mounted) return;
    await Future.wait([
      precacheImage(const AssetImage(AppAssets.bgSplash), context),
      precacheImage(const AssetImage(AppAssets.logo), context),
      precacheImage(const AssetImage(AppAssets.logoMelies), context),
    ]);
  }

  Future<void> _leave() async {
    if (!mounted || _navigated) return;
    _navigated = true;
    _glowCtrl.stop();
    await _fadeCtrl.reverse();
    if (!mounted) return;
    context.go(AppSession.instance.nextRoute());
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
    final bottomSafe = media.padding.bottom;
    final size = media.size;

    return Scaffold(
      backgroundColor: const Color(0xFF7EB8C9),
      body: FadeTransition(
        opacity: _fade,
        child: AbsorbPointer(
          child: SizedBox.expand(
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
                        Colors.black.withValues(alpha: 0.28),
                      ],
                      stops: const [0, 0.42, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.20,
                  left: 28,
                  right: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                                    width: 175,
                                    height: 98,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(85),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: _glowPulse.value,
                                          ),
                                          blurRadius: 50,
                                          spreadRadius: 12,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const EcoLogo(height: 122),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      FadeTransition(
                        opacity: _tagOpacity,
                        child: SlideTransition(
                          position: _tagSlide,
                          child: ScaleTransition(
                            scale: _tagScale,
                            child: Text(
                              'Le patrimoine autrement',
                              textAlign: TextAlign.center,
                              style: AppFonts.playfair(
                                color: AppColors.primaryTealMid,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: bottomSafe + 18,
                  child: FadeTransition(
                    opacity: _meliesOpacity,
                    child: SlideTransition(
                      position: _meliesSlide,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'DÉVELOPPÉE PAR',
                            textAlign: TextAlign.center,
                            style: AppFonts.dmSans(
                              color: const Color(0xFFF2F0EA),
                              fontSize: 13,
                              letterSpacing: 3.0,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const MeliesLogo(height: 128),
                        ],
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
