import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';
import '../utils/form_validators.dart';
import '../widgets/auth_micro_interactions.dart';

/// EcoAR Kerkennah login — hero photo + overlapping cream form card.
class EcoArLoginScreen extends StatefulWidget {
  const EcoArLoginScreen({super.key});

  @override
  State<EcoArLoginScreen> createState() => _EcoArLoginScreenState();
}

class _EcoArLoginScreenState extends State<EcoArLoginScreen> {
  static const _navy = Color(0xFF1B4A5A);
  static const _cream = Color(0xFFFAF7F0);

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

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
    context.push('/forgot-password');
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
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const logoH = 96.0;
    const logoTopPad = 48.0;
    const logoBottomPad = 64.0;
    final heroH = topInset + logoTopPad + logoH + logoBottomPad;
    const bottomPeek = 12.0;

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
                      padding: EdgeInsets.only(
                        top: topInset + logoTopPad,
                        bottom: logoBottomPad,
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.logoGold,
                          height: logoH,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Image.asset(
                            AppAssets.logo,
                            height: logoH,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Cream card — same floating inset style as signup
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 16),
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
                      autovalidateMode: _submitted
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          textInputAction: TextInputAction.next,
                          autofillHints: const [
                            AutofillHints.username,
                            AutofillHints.email,
                            AutofillHints.telephoneNumber,
                          ],
                          validator: FormValidators.loginIdentifier,
                        ),
                        const SizedBox(height: 14),
                        _PillField(
                          controller: _password,
                          hint: 'Mot de passe',
                          prefix: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => _onLogin(),
                          validator: FormValidators.loginPassword,
                          suffix: AuthBounceIconButton(
                            tooltip: _obscure
                                ? 'Afficher le mot de passe'
                                : 'Masquer le mot de passe',
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: _obscure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AuthTextLink(
                            label: 'Mot de passe oublié ?',
                            onTap: _onForgotPassword,
                          ),
                        ),
                        const SizedBox(height: 22),
                        AuthPrimaryButton(
                          label: 'Se connecter',
                          loading: _loading,
                          onPressed: _loading ? null : _onLogin,
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
                        AuthSocialButton(
                          label: 'Continuer avec Google',
                          onPressed: _loading ? null : _onGoogle,
                          leading: const _GoogleMark(),
                        ),
                        const SizedBox(height: 10),
                        AuthSocialButton(
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
                              AuthTextLink(
                                label: "S'inscrire",
                                onTap: _onSignUp,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
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

class _PillField extends StatefulWidget {
  const _PillField({
    required this.controller,
    required this.hint,
    required this.prefix,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints,
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
  final Iterable<String>? autofillHints;

  @override
  State<_PillField> createState() => _PillFieldState();
}

class _PillFieldState extends State<_PillField> {
  static const _navy = Color(0xFF1B4A5A);
  static const _border = Color(0xFFD8E3E8);

  late final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      final next = _focus.hasFocus;
      if (next != _focused) setState(() => _focused = next);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: _navy.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focus,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppFonts.dmSans(fontSize: 15, color: _navy),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
        ],
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppFonts.dmSans(
            fontSize: 14,
            color: const Color(0xFF9AA8AE),
          ),
          prefixIcon: AuthAnimatedIcon(
            icon: widget.prefix,
            focused: _focused,
          ),
          suffixIcon: widget.suffix,
          filled: true,
          fillColor: Colors.white,
          errorMaxLines: 2,
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
            borderSide: const BorderSide(color: _navy, width: 1.6),
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
      ),
    );
  }
}

/// Official Google "G" mark for the social login pill.
class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.socialGoogle,
      width: 26,
      height: 26,
      fit: BoxFit.contain,
    );
  }
}
