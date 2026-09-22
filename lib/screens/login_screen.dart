import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/app_toast.dart';
import '../widgets/common_widgets.dart';

/// Login — CEO mock: coastal hero + cream sheet form.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  static const _sheetCream = Color(0xFFFDFBF7);

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toast(String message, {bool error = true}) {
    if (error) {
      AppToast.error(context, message);
    } else {
      AppToast.success(context, message);
    }
  }

  Future<void> _submit() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final result = AuthService.instance.login(
      identifier: _identifier.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.success) {
      _toast(result.message, error: false);
      AppNav.goHome(context);
    } else {
      _toast(result.message);
    }
  }

  Future<void> _social(String provider) async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 120));
    AuthService.instance.continueAsGuest(provider: provider);
    if (!mounted) return;
    setState(() => _loading = false);
    AppNav.goHome(context);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottom = media.padding.bottom;
    final h = media.size.height;
    final sheetTop = h * 0.355;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _sheetCream,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // —— Hero photo (exact mock scene) ——
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: sheetTop + 40,
            child: Image.asset(
              AppAssets.bgLoginHero,
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.2),
              gaplessPlayback: true,
              errorBuilder: (_, __, ___) => Image.asset(
                AppAssets.bgOnboardingHarbor,
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.2),
              ),
            ),
          ),

          // Gold brand over sky
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: sheetTop,
            child: SafeArea(
              bottom: false,
              child: Align(
                alignment: const Alignment(0, -0.35),
                child: Image.asset(
                  AppAssets.logo,
                  height: 72,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // —— Cream login sheet ——
          Positioned(
            top: sheetTop,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: _sheetCream,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 28,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(26, 30, 26, 16 + bottom),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                      Text(
                        'Connectez-vous et explorez Kerkennah',
                        textAlign: TextAlign.center,
                        style: AppFonts.playfair(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Accédez à des parcours uniques et vivez le patrimoine des îles autrement.',
                        textAlign: TextAlign.center,
                        style: AppFonts.dmSans(
                          fontSize: 13.5,
                          color: AppColors.textSecondary,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 22),
                      _AuthField(
                        controller: _identifier,
                        hint: 'Email ou numéro de téléphone',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _AuthField(
                        controller: _password,
                        hint: 'Mot de passe',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                          icon: Icon(
                            _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => _toast(
                            'Compte démo: ${AuthService.demoEmail} / ${AuthService.demoPassword}',
                            error: false,
                          ),
                          child: Text(
                            'Mot de passe oublié ?',
                            style: AppFonts.dmSans(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: _loading ? 'Connexion...' : 'Se connecter',
                        onPressed: _loading ? () {} : _submit,
                        enabled: !_loading,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.border.withValues(alpha: 0.9),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'ou continuer avec',
                              style: AppFonts.dmSans(
                                color: AppColors.textSecondary,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.border.withValues(alpha: 0.9),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SecondaryButton(
                        label: 'Continuer avec Google',
                        onPressed: () => _social('google'),
                        leading: const _GoogleMark(),
                      ),
                      const SizedBox(height: 10),
                      SecondaryButton(
                        label: 'Continuer avec Apple',
                        onPressed: () => _social('apple'),
                        leading: const Icon(
                          Icons.apple,
                          size: 22,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text.rich(
                        TextSpan(
                          style: AppFonts.dmSans(
                            color: AppColors.textSecondary,
                            fontSize: 13.5,
                          ),
                          children: [
                            const TextSpan(text: 'Pas encore de compte ? '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () => context.push('/signup'),
                                child: Text(
                                  "S'inscrire",
                                  style: AppFonts.dmSans(
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.18
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(
      center: Offset(s / 2, s / 2),
      radius: s * 0.36,
    );

    stroke.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -0.15, 1.55, false, stroke);
    stroke.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 1.4, 1.0, false, stroke);
    stroke.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 2.4, 0.85, false, stroke);
    stroke.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 3.25, 1.0, false, stroke);

    canvas.drawRect(
      Rect.fromLTWH(s * 0.48, s * 0.42, s * 0.38, s * 0.16),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE6E2DA);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: AppFonts.dmSans(
        color: AppColors.navy,
        fontWeight: FontWeight.w500,
        fontSize: 14.5,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(
          color: const Color(0xFF9AA3AA),
          fontSize: 14.5,
        ),
        prefixIcon: Icon(icon, color: AppColors.navy, size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.3),
        ),
      ),
    );
  }
}
