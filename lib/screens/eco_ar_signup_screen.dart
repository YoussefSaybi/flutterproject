import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';
import '../utils/form_validators.dart';
import '../widgets/auth_micro_interactions.dart';

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
  bool _submitted = false;
  int _passwordScore = 0;

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = _onTerms;
    _privacyTap = TapGestureRecognizer()..onTap = _onPrivacy;
    _password.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final score = FormValidators.passwordStrength(_password.text);
    if (score != _passwordScore) {
      setState(() => _passwordScore = score);
    }
  }

  @override
  void dispose() {
    _password.removeListener(_onPasswordChanged);
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
    setState(() => _submitted = true);
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
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    const logoH = 88.0;
    const logoTopPad = 32.0;
    const logoBottomPad = 64.0;
    final heroH = topInset + logoTopPad + logoH + logoBottomPad;
    const bottomPeek = 12.0;
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
                  // Cream card — inset sides so photo peeks L/R; no translate
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.fromLTRB(28, 48, 28, 16),
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
                              textCapitalization: TextCapitalization.words,
                              autofillHints: const [AutofillHints.name],
                              validator: FormValidators.name,
                            ),
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _email,
                              hint: 'Email',
                              prefix: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: FormValidators.email,
                            ),
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _password,
                              hint: 'Mot de passe',
                              prefix: Icons.lock_outline_rounded,
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              suffix: AuthBounceIconButton(
                                tooltip: _isPasswordVisible
                                    ? 'Masquer le mot de passe'
                                    : 'Afficher le mot de passe',
                                onPressed: () => setState(
                                  () =>
                                      _isPasswordVisible = !_isPasswordVisible,
                                ),
                                icon: _isPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              validator: FormValidators.password,
                            ),
                            if (_password.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _PasswordStrengthBar(score: _passwordScore),
                            ],
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _confirmPassword,
                              hint: 'Confirmer le mot de passe',
                              prefix: Icons.lock_outline_rounded,
                              obscureText: !_isConfirmPasswordVisible,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) {
                                if (canSubmit) _onSignUp();
                              },
                              suffix: AuthBounceIconButton(
                                tooltip: _isConfirmPasswordVisible
                                    ? 'Masquer le mot de passe'
                                    : 'Afficher le mot de passe',
                                onPressed: () => setState(
                                  () => _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible,
                                ),
                                icon: _isConfirmPasswordVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              validator: (v) => FormValidators.confirmPassword(
                                v,
                                _password.text,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: AuthAnimatedCheckbox(
                                    value: _acceptedTerms,
                                    onChanged: (v) => setState(
                                      () => _acceptedTerms = v ?? false,
                                    ),
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
                            AuthPrimaryButton(
                              label: "S'inscrire",
                              loading: _loading,
                              onPressed: canSubmit ? _onSignUp : null,
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
                                  AuthTextLink(
                                    label: 'Se connecter',
                                    onTap: _onLoginLink,
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

class _PillFormField extends StatefulWidget {
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
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
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
  final TextCapitalization textCapitalization;

  @override
  State<_PillFormField> createState() => _PillFormFieldState();
}

class _PillFormFieldState extends State<_PillFormField> {
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
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppFonts.dmSans(fontSize: 15, color: _navy),
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

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF8B2E2E),
      Color(0xFFC97B3A),
      Color(0xFFC9A05C),
      Color(0xFF2F7A4A),
      Color(0xFF1B6B3A),
    ];
    final color = colors[score.clamp(0, 4)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final filled = i < score;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: filled ? color : const Color(0xFFD8E3E8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 280),
          style: AppFonts.dmSans(
            fontSize: 11,
            color: color,
            height: 1.3,
          ),
          child: Text(
            'Sécurité : ${FormValidators.passwordStrengthLabel(score)}'
            ' — 8+ car., majuscule, minuscule, chiffre, symbole',
          ),
        ),
      ],
    );
  }
}
