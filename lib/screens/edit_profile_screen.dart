import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    _name = TextEditingController(text: user?.name ?? 'Mohamed Azmi');
    _email = TextEditingController(text: user?.email ?? AuthService.demoEmail);
    _phone = TextEditingController(
      text: (user?.phone.isNotEmpty ?? false) ? user!.phone : '+216 24 349 288',
    );
    _city = TextEditingController(
      text: (user?.city.isNotEmpty ?? false) ? user!.city : 'Sfax, Tunisie',
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _city.dispose();
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

  Future<void> _save() async {
    if (_saving) return;
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 150));
    AuthService.instance.updateProfile(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      city: _city.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    _toast('Profil mis à jour.', error: false);
    AppNav.popOr(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.cream,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          TealHeader(
            showBack: true,
            showLanguage: true,
            onBack: () => AppNav.popOr(context, '/profile'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(22, 24, 22, 24 + bottom),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Modifier le profil',
                      textAlign: TextAlign.center,
                      style: AppFonts.playfair(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mettez à jour vos informations personnelles pour une meilleure expérience.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        const CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(AppAssets.bgCoast),
                        ),
                        SoftCircleButton(
                          onPressed: () {},
                          icon: Icons.photo_camera_outlined,
                          background: AppColors.navy,
                          foreground: AppColors.white,
                          size: 34,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _PillField(
                      controller: _name,
                      label: 'Nom complet',
                      icon: Icons.person_outline_rounded,
                      validator: (v) =>
                          (v == null || v.trim().length < 2) ? 'Nom invalide' : null,
                    ),
                    const SizedBox(height: 12),
                    _PillField(
                      controller: _email,
                      label: 'Email',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !AuthService.isValidEmail(v))
                              ? 'Email invalide'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    _PillField(
                      controller: _phone,
                      label: 'Téléphone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _PillField(
                      controller: _city,
                      label: 'Ville',
                      icon: Icons.place_outlined,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      label: _saving
                          ? 'Enregistrement...'
                          : 'Enregistrer les modifications',
                      onPressed: _saving ? () {} : _save,
                      enabled: !_saving,
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

class _PillField extends StatelessWidget {
  const _PillField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: AppFonts.dmSans(
        color: AppColors.navy,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppFonts.dmSans(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.navy),
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          borderSide: const BorderSide(color: Color(0xFF8B2E2E)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppLayout.radiusPill),
          borderSide: const BorderSide(color: Color(0xFF8B2E2E), width: 1.4),
        ),
      ),
    );
  }
}
