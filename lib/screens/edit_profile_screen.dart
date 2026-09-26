import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/app_toast.dart';
import '../widgets/common_widgets.dart';
import '../widgets/profile_photo.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  bool _saving = false;
  bool _picking = false;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    _name = TextEditingController(text: user?.name ?? 'Emna El Abed');
    _email = TextEditingController(
      text: user?.email ?? 'emna.el.abed.dev@gmail.com',
    );
    _phone = TextEditingController(
      text: (user?.phone.isNotEmpty ?? false) ? user!.phone : '+216 24 349 288',
    );
    _city = TextEditingController(
      text: (user?.city.isNotEmpty ?? false) ? user!.city : 'Kerkennah, Sfax',
    );
    _photoPath = AuthService.instance.profilePhotoPath;
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
    if (error) {
      AppToast.error(context, message);
    } else {
      AppToast.success(context, message);
    }
  }

  Future<void> _showPhotoSheet() async {
    if (_picking) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 18),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD5CFC4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                'Photo de profil',
                style: AppFonts.playfair(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Prenez une photo ou importez-en une depuis la galerie.',
                textAlign: TextAlign.center,
                style: AppFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              _SheetAction(
                icon: Icons.photo_camera_outlined,
                label: 'Prendre une photo',
                onTap: () {
                  Navigator.pop(ctx);
                  _pick(ImageSource.camera);
                },
              ),
              _SheetAction(
                icon: Icons.photo_library_outlined,
                label: 'Choisir depuis la galerie',
                onTap: () {
                  Navigator.pop(ctx);
                  _pick(ImageSource.gallery);
                },
              ),
              if (_photoPath != null && _photoPath!.isNotEmpty)
                _SheetAction(
                  icon: Icons.delete_outline_rounded,
                  label: 'Supprimer la photo',
                  danger: true,
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => _photoPath = null);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pick(ImageSource source) async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 88,
      );
      if (file == null) {
        if (mounted) setState(() => _picking = false);
        return;
      }
      final saved = await _persistPickedFile(file.path);
      if (!mounted) return;
      setState(() {
        _photoPath = saved;
        _picking = false;
      });
      _toast('Photo ajoutée.', error: false);
    } catch (_) {
      if (!mounted) return;
      setState(() => _picking = false);
      _toast(
        source == ImageSource.camera
            ? 'Impossible d’ouvrir la caméra. Vérifiez les permissions.'
            : 'Impossible d’ouvrir la galerie. Vérifiez les permissions.',
      );
    }
  }

  Future<String> _persistPickedFile(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(dir.path, 'profile_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    final ext = p.extension(sourcePath).isEmpty ? '.jpg' : p.extension(sourcePath);
    final dest = p.join(
      photosDir.path,
      'avatar_${DateTime.now().millisecondsSinceEpoch}$ext',
    );
    await File(sourcePath).copy(dest);
    return dest;
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
      photoPath: _photoPath,
      clearPhoto: _photoPath == null || _photoPath!.isEmpty,
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
            showLanguage: false,
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
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.7),
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: ProfilePhoto(
                              path: _photoPath,
                              size: 96,
                            ),
                          ),
                        ),
                        SoftCircleButton(
                          onPressed: _picking ? () {} : _showPhotoSheet,
                          icon: _picking
                              ? Icons.hourglass_top_rounded
                              : Icons.photo_camera_outlined,
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
                      validator: (v) => (v == null || v.trim().length < 2)
                          ? 'Nom invalide'
                          : null,
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

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? const Color(0xFF8B2E2E) : AppColors.navy;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: AppFonts.dmSans(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
