import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';
import '../utils/form_validators.dart';

/// EcoAR Kerkennah — forgot password (email → code → new password).
class EcoArForgotPasswordScreen extends StatefulWidget {
  const EcoArForgotPasswordScreen({super.key});

  @override
  State<EcoArForgotPasswordScreen> createState() =>
      _EcoArForgotPasswordScreenState();
}

class _EcoArForgotPasswordScreenState extends State<EcoArForgotPasswordScreen> {
  static const _navy = Color(0xFF1B4A5A);
  static const _cream = Color(0xFFFAF7F0);

  final _emailFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  /// 0 = enter email, 1 = enter code + new password, 2 = done
  int _step = 0;
  bool _loading = false;
  bool _submitted = false;
  bool _obscure = true;
  bool _obscureConfirm = true;
  int _passwordScore = 0;

  static const _goldKnockout = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1, 0, 0,
    0.35, 0.35, 0.35, 0, 0,
  ]);

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      final s = FormValidators.passwordStrength(_password.text);
      if (s != _passwordScore) setState(() => _passwordScore = s);
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!(_emailFormKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final result = AuthService.instance.requestPasswordReset(email: _email.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _step = 1;
      _submitted = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: _navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _resetPassword() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (!(_resetFormKey.currentState?.validate() ?? false)) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final result = AuthService.instance.resetPassword(
      email: _email.text,
      code: _code.text,
      newPassword: _password.text,
      confirmPassword: _confirm.text,
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
    if (result.success) {
      setState(() {
        _step = 2;
        _submitted = false;
      });
    }
  }

  void _goLogin() => context.go('/login');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final heroH = size.height * 0.30;
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
                    child: Stack(
                      children: [
                        Positioned(
                          top: topInset + 4,
                          left: 8,
                          child: IconButton(
                            onPressed: () {
                              if (_step == 1) {
                                setState(() {
                                  _step = 0;
                                  _submitted = false;
                                });
                              } else {
                                _goLogin();
                              }
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.white,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.25),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.15),
                          child: Padding(
                            padding: EdgeInsets.only(top: topInset + 8),
                            child: ColorFiltered(
                              colorFilter: _goldKnockout,
                              child: Image.asset(
                                AppAssets.logoGold,
                                width: size.width * 0.62,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  AppAssets.logo,
                                  width: size.width * 0.62,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints(
                      minHeight: size.height - heroH - bottomPeek - 8,
                    ),
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
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
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      child: _step == 0
                          ? _EmailStep(
                              key: const ValueKey('email'),
                              formKey: _emailFormKey,
                              email: _email,
                              submitted: _submitted,
                              loading: _loading,
                              onSubmit: _sendCode,
                              onLogin: _goLogin,
                            )
                          : _step == 1
                              ? _ResetStep(
                                  key: const ValueKey('reset'),
                                  formKey: _resetFormKey,
                                  email: _email.text.trim(),
                                  code: _code,
                                  password: _password,
                                  confirm: _confirm,
                                  submitted: _submitted,
                                  loading: _loading,
                                  obscure: _obscure,
                                  obscureConfirm: _obscureConfirm,
                                  passwordScore: _passwordScore,
                                  onToggleObscure: () =>
                                      setState(() => _obscure = !_obscure),
                                  onToggleConfirm: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  onSubmit: _resetPassword,
                                  onResend: _sendCode,
                                )
                              : _DoneStep(
                                  key: const ValueKey('done'),
                                  onLogin: _goLogin,
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

class _EmailStep extends StatelessWidget {
  const _EmailStep({
    super.key,
    required this.formKey,
    required this.email,
    required this.submitted,
    required this.loading,
    required this.onSubmit,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final bool submitted;
  final bool loading;
  final VoidCallback onSubmit;
  final VoidCallback onLogin;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mot de passe oublié',
            textAlign: TextAlign.center,
            style: AppFonts.playfair(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Saisissez votre email. Nous vous enverrons un code pour réinitialiser votre mot de passe.',
            textAlign: TextAlign.center,
            style: AppFonts.dmSans(
              fontSize: 14,
              color: const Color(0xFF6B7A80),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 28),
          _PillField(
            controller: email,
            hint: 'Email',
            prefix: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: FormValidators.email,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: 'Envoyer le code',
            loading: loading,
            onPressed: loading ? null : onSubmit,
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: onLogin,
              child: Text(
                'Retour à la connexion',
                style: AppFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetStep extends StatelessWidget {
  const _ResetStep({
    super.key,
    required this.formKey,
    required this.email,
    required this.code,
    required this.password,
    required this.confirm,
    required this.submitted,
    required this.loading,
    required this.obscure,
    required this.obscureConfirm,
    required this.passwordScore,
    required this.onToggleObscure,
    required this.onToggleConfirm,
    required this.onSubmit,
    required this.onResend,
  });

  final GlobalKey<FormState> formKey;
  final String email;
  final TextEditingController code;
  final TextEditingController password;
  final TextEditingController confirm;
  final bool submitted;
  final bool loading;
  final bool obscure;
  final bool obscureConfirm;
  final int passwordScore;
  final VoidCallback onToggleObscure;
  final VoidCallback onToggleConfirm;
  final VoidCallback onSubmit;
  final VoidCallback onResend;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Nouveau mot de passe',
            textAlign: TextAlign.center,
            style: AppFonts.playfair(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Code envoyé à $email',
            textAlign: TextAlign.center,
            style: AppFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF6B7A80),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          _PillField(
            controller: code,
            hint: 'Code à 6 chiffres',
            prefix: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (v) {
              final c = (v ?? '').trim();
              if (c.isEmpty) return 'Le code est requis.';
              if (!RegExp(r'^\d{6}$').hasMatch(c)) {
                return 'Le code doit contenir 6 chiffres.';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          _PillField(
            controller: password,
            hint: 'Nouveau mot de passe',
            prefix: Icons.lock_outline_rounded,
            obscureText: obscure,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            validator: FormValidators.password,
            suffix: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _navy.withValues(alpha: 0.45),
                size: 22,
              ),
            ),
          ),
          if (password.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            _StrengthBar(score: passwordScore),
          ],
          const SizedBox(height: 14),
          _PillField(
            controller: confirm,
            hint: 'Confirmer le mot de passe',
            prefix: Icons.lock_outline_rounded,
            obscureText: obscureConfirm,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmit(),
            validator: (v) =>
                FormValidators.confirmPassword(v, password.text),
            suffix: IconButton(
              onPressed: onToggleConfirm,
              icon: Icon(
                obscureConfirm
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: _navy.withValues(alpha: 0.45),
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 22),
          _PrimaryButton(
            label: 'Réinitialiser',
            loading: loading,
            onPressed: loading ? null : onSubmit,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: loading ? null : onResend,
              child: Text(
                'Renvoyer le code',
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({super.key, required this.onLogin});

  final VoidCallback onLogin;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Icon(Icons.check_circle_rounded, size: 64, color: _navy),
        const SizedBox(height: 18),
        Text(
          'Mot de passe mis à jour',
          textAlign: TextAlign.center,
          style: AppFonts.playfair(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.',
          textAlign: TextAlign.center,
          style: AppFonts.dmSans(
            fontSize: 14,
            color: const Color(0xFF6B7A80),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 28),
        _PrimaryButton(
          label: 'Se connecter',
          loading: false,
          onPressed: onLogin,
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _navy.withValues(alpha: 0.4),
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: loading
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
                    label,
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
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
    this.autofillHints,
    this.inputFormatters,
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
  final List<TextInputFormatter>? inputFormatters;

  static const _navy = Color(0xFF1B4A5A);
  static const _border = Color(0xFFD8E3E8);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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

class _StrengthBar extends StatelessWidget {
  const _StrengthBar({required this.score});

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
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < score ? color : const Color(0xFFD8E3E8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Sécurité : ${FormValidators.passwordStrengthLabel(score)}',
          style: AppFonts.dmSans(fontSize: 11, color: color),
        ),
      ],
    );
  }
}
