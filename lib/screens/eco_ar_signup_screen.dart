import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';

/// EcoAR Kerkennah sign-up — coastal hero + cream form card (mock layout).
class EcoArSignUpScreen extends StatefulWidget {
  const EcoArSignUpScreen({super.key});

  @override
  State<EcoArSignUpScreen> createState() => _EcoArSignUpScreenState();
}

class _EcoArSignUpScreenState extends State<EcoArSignUpScreen> {
  static const _navy = Color(0xFF1B4A5A);
  static const _cream = Color(0xFFFAF7F0);

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptedTerms = false;
  bool _loading = false;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  /// Knock out black plate so only gold shows on the photo.
  static const _goldKnockout = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0.35, 0.35, 0.35, 0, 0,
  ]);

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = _onTerms;
    _privacyTap = TapGestureRecognizer()..onTap = _onPrivacy;
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _onTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Conditions d'utilisation — bientôt disponible."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onPrivacy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Politique de confidentialité — bientôt disponible.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onLoginLink() {
    context.go('/login');
  }

  Future<void> _onSignUp() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez accepter les conditions d'utilisation."),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _loading = true);
    final result = AuthService.instance.signUp(
      name: _name.text,
      email: _email.text,
      password: _password.text,
      confirmPassword: _confirmPassword.text,
      acceptedTerms: _acceptedTerms,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final heroH = size.height * 0.34;
    final bottomPeek = size.height * 0.06;
    final canSubmit = _acceptedTerms && !_loading;

    return Scaffold(
      backgroundColor: const Color(0xFF3AABB8),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.bgSignupHero,
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
                  // Top zone: official gold EcoAR logo on coastal sky
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
                  // Cream card — inset sides so photo peeks L/R; no translate
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Créer un compte',
                              textAlign: TextAlign.center,
                              style: AppFonts.playfair(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: _navy,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Rejoignez EcoAR Kerkennah et explorez un patrimoine unique.',
                              textAlign: TextAlign.center,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: const Color(0xFF6B7A80),
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _PillFormField(
                              controller: _name,
                              hint: 'Nom complet',
                              prefix: Icons.person_outline_rounded,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Le nom est requis.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _email,
                              hint: 'Email',
                              prefix: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return "L'email est requis.";
                                }
                                if (!AuthService.isValidEmail(v)) {
                                  return 'Adresse email invalide.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _password,
                              hint: 'Mot de passe',
                              prefix: Icons.lock_outline_rounded,
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.next,
                              suffix: IconButton(
                                tooltip: _isPasswordVisible
                                    ? 'Masquer le mot de passe'
                                    : 'Afficher le mot de passe',
                                onPressed: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: _navy.withValues(alpha: 0.45),
                                  size: 22,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Le mot de passe est requis.';
                                }
                                if (v.length < 8) {
                                  return 'Au moins 8 caractères.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _confirmPassword,
                              hint: 'Confirmer le mot de passe',
                              prefix: Icons.lock_outline_rounded,
                              obscureText: !_isConfirmPasswordVisible,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) {
                                if (canSubmit) _onSignUp();
                              },
                              suffix: IconButton(
                                tooltip: _isConfirmPasswordVisible
                                    ? 'Masquer le mot de passe'
                                    : 'Afficher le mot de passe',
                                onPressed: () => setState(
                                  () => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                                ),
                                icon: Icon(
                                  _isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: _navy.withValues(alpha: 0.45),
                                  size: 22,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Confirmez le mot de passe.';
                                }
                                if (v != _password.text) {
                                  return 'Les mots de passe ne correspondent pas.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _acceptedTerms,
                                    onChanged: (v) => setState(
                                      () => _acceptedTerms = v ?? false,
                                    ),
                                    activeColor: _navy,
                                    checkColor: Colors.white,
                                    side: BorderSide(
                                      color: _navy.withValues(alpha: 0.5),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppFonts.dmSans(
                                        fontSize: 13,
                                        color: _navy.withValues(alpha: 0.85),
                                        height: 1.35,
                                      ),
                                      children: [
                                        const TextSpan(text: "J'accepte les "),
                                        TextSpan(
                                          text: "Conditions d'utilisation",
                                          style: AppFonts.dmSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _navy,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: _termsTap,
                                        ),
                                        const TextSpan(text: ' et la '),
                                        TextSpan(
                                          text:
                                              'Politique de confidentialité',
                                          style: AppFonts.dmSans(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: _navy,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: _privacyTap,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: canSubmit ? _onSignUp : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _navy,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      _navy.withValues(alpha: 0.35),
                                  disabledForegroundColor:
                                      Colors.white.withValues(alpha: 0.75),
                                  elevation: 0,
                                  shape: const StadiumBorder(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                  ),
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
                                            "S'inscrire",
                                            style: AppFonts.dmSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.chevron_right,
                                            size: 22,
                                          ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Text(
                                    'ou',
                                    style: AppFonts.dmSans(
                                      fontSize: 13,
                                      color: _navy.withValues(alpha: 0.5),
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
                            const SizedBox(height: 20),
                            Center(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Vous avez déjà un compte ? ',
                                    style: AppFonts.dmSans(
                                      fontSize: 14,
                                      color: _navy.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _onLoginLink,
                                    child: Text(
                                      'Se connecter',
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

class _PillFormField extends StatelessWidget {
  const _PillFormField({
    required this.controller,
    required this.hint,
    required this.prefix,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  static const _navy = Color(0xFF1B4A5A);
  static const _border = Color(0xFFD8E3E8);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF8B2E2E)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF8B2E2E), width: 1.4),
        ),
      ),
    );
  }
}
