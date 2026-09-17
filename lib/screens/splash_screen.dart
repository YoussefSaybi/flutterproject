import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _go() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go(AuthService.instance.isLoggedIn ? '/home' : '/onboarding');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future<void>.delayed(const Duration(milliseconds: 2400), _go);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _go,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(AppAssets.bgCoast, fit: BoxFit.cover),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  const EcoLogo(height: 96),
                  const SizedBox(height: 12),
                  Text(
                    'Le patrimoine autrement',
                    style: AppFonts.playfair(
                      color: AppColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(flex: 4),
                  Text(
                    'Méliès',
                    style: AppFonts.greatVibes(color: AppColors.gold, fontSize: 40),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'SOCIÉTÉ DE PRODUCTION',
                    style: AppFonts.dmSans(
                      color: AppColors.gold,
                      fontSize: 10,
                      letterSpacing: 2.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 32 + bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
