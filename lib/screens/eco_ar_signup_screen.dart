import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';
import '../utils/form_validators.dart';
import '../widgets/advanced_field_validation.dart';
import '../widgets/app_toast.dart';
import '../widgets/auth_error_popup.dart';
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
  String _nameLive = '';
  String _emailLive = '';
  String _passwordLive = '';
  String _confirmLive = '';

  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = _onTerms;
    _privacyTap = TapGestureRecognizer()..onTap = _onPrivacy;
    _name.addListener(() => setState(() => _nameLive = _name.text));
    _email.addListener(() => setState(() => _emailLive = _email.text));
    _password.addListener(_onPasswordChanged);
    _confirmPassword
        .addListener(() => setState(() => _confirmLive = _confirmPassword.text));
  }

  void _onPasswordChanged() {
    setState(() {
      _passwordLive = _password.text;
    });
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
    AppToast.info(
      context,
      "Conditions d'utilisation — bientôt disponible.",
    );
  }

  void _onPrivacy() {
    AppToast.info(
      context,
      'Politique de confidentialité — bientôt disponible.',
    );
  }

  void _onLoginLink() {
    context.go('/login');
  }

  Future<void> _onSignUp() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();

    final nameErr = FormValidators.name(_name.text);
    final emailErr = FormValidators.email(_email.text);
    final passErr = FormValidators.password(_password.text);
    final confirmErr =
        FormValidators.confirmPassword(_confirmPassword.text, _password.text);
    final firstErr = nameErr ?? emailErr ?? passErr ?? confirmErr;
    if (firstErr != null) {
      await showAuthErrorPopup(context, message: firstErr);
      return;
    }
    if (!_acceptedTerms) {
      await showAuthErrorPopup(
        context,
        message: "Veuillez accepter les conditions d'utilisation.",
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
    if (result.success) {
      AppNav.goHome(context);
    } else {
      await showAuthErrorPopup(
        context,
        title: 'Inscription',
        message: result.message,
      );
    }
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
                        autovalidateMode: AutovalidateMode.disabled,
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
                              showValidBorder: FormValidators.name(_nameLive) == null &&
                                  _nameLive.trim().isNotEmpty,
                            ),
                            if (_nameLive.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ValidationRulesPanel(
                                title: 'Contrôle du nom',
                                rules: nameRules(_nameLive),
                              ),
                            ],
                            const SizedBox(height: 14),
                            _PillFormField(
                              controller: _email,
                              hint: 'Email',
                              prefix: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              validator: FormValidators.email,
                              showValidBorder: FormValidators.email(_emailLive) == null &&
                                  _emailLive.trim().isNotEmpty,
                            ),
                            if (_emailLive.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ValidationRulesPanel(
                                title: 'Contrôle de l\'email',
                                rules: emailRules(_emailLive),
                              ),
                            ],
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
                              showValidBorder:
                                  FormValidators.password(_passwordLive) == null &&
                                      _passwordLive.isNotEmpty,
                            ),
                            if (_passwordLive.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              PasswordStrengthMeter(password: _passwordLive),
                              const SizedBox(height: 8),
                              ValidationRulesPanel(
                                title: 'Règles du mot de passe',
                                rules: passwordRules(_passwordLive),
                              ),
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
                              showValidBorder: FormValidators.confirmPassword(
                                        _confirmLive,
                                        _passwordLive,
                                      ) ==
                                      null &&
                                  _confirmLive.isNotEmpty,
                            ),
                            if (_confirmLive.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ValidationRulesPanel(
                                title: 'Confirmation',
                                rules: confirmPasswordRules(
                                  _confirmLive,
                                  _passwordLive,
                                ),
                              ),
                            ],
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
    this.showValidBorder = false,
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
  final bool showValidBorder;

  @override
  State<_PillFormField> createState() => _PillFormFieldState();
}

class _PillFormFieldState extends State<_PillFormField> {
  static const _navy = Color(0xFF1B4A5A);
  static const _border = Color(0xFFD8E3E8);
  static const _valid = Color(0xFF2F7A4A);

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
    final borderColor = widget.showValidBorder
        ? _valid
        : (_focused ? _navy : _border);
    final borderWidth = (widget.showValidBorder || _focused) ? 1.6 : 1.0;

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
        autovalidateMode: AutovalidateMode.disabled,
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
          suffixIcon: _buildSuffix(),
          filled: true,
          fillColor: Colors.white,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          errorMaxLines: 1,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: widget.showValidBorder ? _valid : _navy,
              width: 1.6,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: widget.showValidBorder ? _valid : _navy,
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffix() {
    if (!widget.showValidBorder && widget.suffix == null) return null;
    if (widget.suffix == null) {
      return const Icon(Icons.check_circle_rounded, color: _valid, size: 22);
    }
    if (!widget.showValidBorder) return widget.suffix;
    return SizedBox(
      width: 88,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.check_circle_rounded, color: _valid, size: 20),
          widget.suffix!,
        ],
      ),
    );
  }
}
