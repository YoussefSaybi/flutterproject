import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';

/// EcoAR Kerkennah login — hero photo + overlapping cream form card.
class EcoArLoginScreen extends StatefulWidget {
  const EcoArLoginScreen({super.key});

  @override
  State<EcoArLoginScreen> createState() => _EcoArLoginScreenState();
}

class _EcoArLoginScreenState extends State<EcoArLoginScreen> {
  static const _navy = Color(0xFF1B4A5A);
  static const _cream = Color(0xFFFAF7F0);

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  static const _goldKnockout = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0.35, 0.35, 0.35, 0, 0,
  ]);

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    // TODO: replace local demo auth with real backend / OAuth flow
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    final result = AuthService.instance.login(
      identifier: _email.text,
      password: _password.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? _navy : const Color(0xFF8B2E2E),
        behavior: SnackBarBehavior.floating,
      ),
    );
    if (result.success) AppNav.goHome(context);
  }

  void _onForgotPassword() {
    // TODO: navigate to forgot-password / reset flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Réinitialisation du mot de passe — bientôt disponible.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onGoogle() async {
    // TODO: wire Google Sign-In SDK
    if (_loading) return;
    setState(() => _loading = true);
    AuthService.instance.continueAsGuest(provider: 'Google');
    if (!mounted) return;
    setState(() => _loading = false);
    AppNav.goHome(context);
  }

  Future<void> _onApple() async {
    // TODO: wire Sign in with Apple
    if (_loading) return;
    setState(() => _loading = true);
    AuthService.instance.continueAsGuest(provider: 'Apple');
    if (!mounted) return;
    setState(() => _loading = false);
    AppNav.goHome(context);
  }

  void _onSignUp() {
    // TODO: deep-link / analytics before signup if needed
    context.go('/signup');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final heroH = size.height * 0.34;
    final bottomPeek = size.height * 0.06;

    return Scaffold(
      backgroundColor: const Color(0xFF3AABB8),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.bgLoginHero,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => Image.asset(
                AppAssets.bgCoast,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Column(
                children: [
                  SizedBox(
                    height: heroH,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(top: topInset + 8),
                      child: Align(
                        alignment: const Alignment(0, -0.2),
                        child: ColorFiltered(
                          colorFilter: _goldKnockout,
                          child: Image.asset(
                            AppAssets.logoGold,
                            width: size.width * 0.72,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Image.asset(
                              AppAssets.logo,
                              width: size.width * 0.72,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Cream card — same floating inset style as signup
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints(
                      minHeight: size.height - heroH - bottomPeek - 8,
                    ),
                    padding: const EdgeInsets.fromLTRB(28, 48, 28, 44),
                    decoration: BoxDecoration(
                      color: _cream,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Connectez-vous et explorez Kerkennah',
                          textAlign: TextAlign.center,
                          style: AppFonts.playfair(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Accédez à des parcours uniques et vivez le patrimoine des îles autrement.',
                          textAlign: TextAlign.center,
                          style: AppFonts.dmSans(
                            fontSize: 14,
                            color: const Color(0xFF6B7A80),
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _PillField(
                          controller: _email,
                          hint: 'Email ou numéro de téléphone',
                          prefix: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 14),
                        _PillField(
                          controller: _password,
                          hint: 'Mot de passe',
                          prefix: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: _navy.withValues(alpha: 0.45),
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _onForgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Mot de passe oublié ?',
                              style: AppFonts.dmSans(
                                fontSize: 13,
                                color: _navy,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          height: 54,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  _navy.withValues(alpha: 0.45),
                              elevation: 0,
                              shape: const StadiumBorder(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      const Spacer(),
                                      Text(
                                        'Se connecter',
                                        style: AppFonts.dmSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.chevron_right, size: 22),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: _navy.withValues(alpha: 0.18),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ou continuer avec',
                                style: AppFonts.dmSans(
                                  fontSize: 12,
                                  color: _navy.withValues(alpha: 0.55),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: _navy.withValues(alpha: 0.18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _SocialPill(
                          label: 'Continuer avec Google',
                          onPressed: _loading ? null : _onGoogle,
                          leading: const _GoogleMark(),
                        ),
                        const SizedBox(height: 10),
                        _SocialPill(
                          label: 'Continuer avec Apple',
                          onPressed: _loading ? null : _onApple,
                          leading: const Icon(
                            Icons.apple,
                            size: 22,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Pas encore de compte ? ',
                                style: AppFonts.dmSans(
                                  fontSize: 14,
                                  color: _navy.withValues(alpha: 0.7),
                                ),
                              ),
                              GestureDetector(
                                onTap: _onSignUp,
                                child: Text(
                                  "S'inscrire",
                                  style: AppFonts.dmSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _navy,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  SizedBox(height: bottomPeek),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({
    required this.controller,
    required this.hint,
    required this.prefix,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  static const _navy = Color(0xFF1B4A5A);
  static const _border = Color(0xFFD8E3E8);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: AppFonts.dmSans(fontSize: 15, color: _navy),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(
          fontSize: 14,
          color: const Color(0xFF9AA8AE),
        ),
        prefixIcon: Icon(prefix, color: _navy.withValues(alpha: 0.5), size: 22),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: _navy, width: 1.5),
        ),
      ),
    );
  }
}

class _SocialPill extends StatelessWidget {
  const _SocialPill({
    required this.label,
    required this.leading,
    required this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: _navy,
          side: BorderSide(color: _navy.withValues(alpha: 0.14)),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 10),
            Text(
              label,
              style: AppFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple Google "G" mark without an extra asset dependency.
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
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    final sweep = [
      (const Color(0xFF4285F4), 0.0, 1.6),
      (const Color(0xFF34A853), 1.6, 0.9),
      (const Color(0xFFFBBC05), 2.5, 0.7),
      (const Color(0xFFEA4335), 3.2, 0.9),
    ];
    for (final (c, start, span) in sweep) {
      paint.color = c;
      canvas.drawArc(rect.deflate(1.5), start, span, false, paint);
    }
    paint
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.48, size.height * 0.42, size.width * 0.42, 2.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
