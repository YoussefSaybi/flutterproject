import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _toast(String message, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppFonts.dmSans(color: Colors.white)),
        backgroundColor: error ? const Color(0xFF8B2E2E) : AppColors.navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submit() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
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
    final bottom = MediaQuery.paddingOf(context).bottom;
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          SizedBox(
            height: h * 0.35,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AppAssets.bgCoast, fit: BoxFit.cover),
                Container(color: Colors.black.withValues(alpha: 0.08)),
                const SafeArea(
                  bottom: false,
                  child: Center(child: EcoLogo(height: 72)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24, 28, 24, 20 + bottom),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Connectez-vous et explorez Kerkennah',
                          textAlign: TextAlign.center,
                          style: AppFonts.playfair(
                            fontSize: 26,
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
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _AuthField(
                          controller: _identifier,
                          hint: 'Email ou numéro de téléphone',
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Champ requis';
                            if (!AuthService.isValidIdentifier(v)) {
                              return 'Email ou téléphone invalide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _AuthField(
                          controller: _password,
                          hint: 'Mot de passe',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          suffix: IconButton(
                            onPressed: () => setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Champ requis';
                            if (v.length < 6) return 'Minimum 6 caractères';
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _toast(
                              'Compte démo: ${AuthService.demoEmail} / ${AuthService.demoPassword}',
                              error: false,
                            ),
                            child: Text(
                              'Mot de passe oublié ?',
                              style: AppFonts.dmSans(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        PrimaryButton(
                          label: _loading ? 'Connexion...' : 'Se connecter',
                          onPressed: _loading ? () {} : _submit,
                          enabled: !_loading,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: AppColors.border)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'ou continuer avec',
                                style: AppFonts.dmSans(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: AppColors.border)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _SocialPill(
                                label: 'Google',
                                icon: Icons.g_mobiledata_rounded,
                                onTap: () => _social('google'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SocialPill(
                                label: 'Apple',
                                icon: Icons.apple,
                                onTap: () => _social('apple'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pas encore de compte ? ',
                              style: AppFonts.dmSans(color: AppColors.textSecondary),
                            ),
                            GestureDetector(
                              onTap: () => context.push('/signup'),
                              child: Text(
                                "S'inscrire",
                                style: AppFonts.dmSans(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            PackIcon(AppAssets.iconLandmarkGold, size: 22, color: AppColors.gold),
                            SizedBox(width: 18),
                            PackIcon(AppAssets.iconBoatGold, size: 22, color: AppColors.gold),
                            SizedBox(width: 18),
                            PackIcon(AppAssets.iconPalm, size: 22, color: AppColors.gold),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      style: AppFonts.dmSans(color: AppColors.navy, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.dmSans(color: AppColors.textSecondary.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: AppColors.navy),
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Color(0xFF8B2E2E)),
        ),
      ),
    );
  }
}

class _SocialPill extends StatelessWidget {
  const _SocialPill({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.navy,
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 6),
          Text(label, style: AppFonts.dmSans(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
