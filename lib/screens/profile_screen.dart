import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_controller.dart';
import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/app_toast.dart';
import '../widgets/common_widgets.dart';
import '../widgets/profile_photo.dart';

/// Profile — teal palm header image + larger white cards (CEO mock).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();
  bool _picking = false;

  Future<void> _showPhotoSheet() async {
    if (_picking) return;
    final hasPhoto =
        (AuthService.instance.currentUser?.photoPath?.isNotEmpty ?? false);
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
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.navy,
                ),
                title: Text(
                  'Prendre une photo',
                  style: AppFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pick(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.navy,
                ),
                title: Text(
                  'Choisir depuis la galerie',
                  style: AppFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pick(ImageSource.gallery);
                },
              ),
              if (hasPhoto)
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFF8B2E2E),
                  ),
                  title: Text(
                    'Supprimer la photo',
                    style: AppFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF8B2E2E),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    AuthService.instance.updateProfile(clearPhoto: true);
                    AppToast.success(context, 'Photo supprimée.');
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
      final dir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(dir.path, 'profile_photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
      final ext =
          p.extension(file.path).isEmpty ? '.jpg' : p.extension(file.path);
      final dest = p.join(
        photosDir.path,
        'avatar_${DateTime.now().millisecondsSinceEpoch}$ext',
      );
      await File(file.path).copy(dest);
      AuthService.instance.updateProfile(photoPath: dest);
      if (!mounted) return;
      setState(() => _picking = false);
      AppToast.success(context, 'Photo mise à jour.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _picking = false);
      AppToast.error(
        context,
        source == ImageSource.camera
            ? 'Impossible d’ouvrir la caméra.'
            : 'Impossible d’ouvrir la galerie.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        LocaleController.instance,
        AuthService.instance,
      ]),
      builder: (context, _) {
        final s = AppStrings.current;
        final user = AuthService.instance.currentUser;
        final name = user?.name ?? 'Emna El Abed';
        final email = user?.email ?? 'emna.el.abed.dev@gmail.com';
        final city = (user?.city.isNotEmpty ?? false)
            ? user!.city
            : 'Kerkennah, Sfax';
        return Scaffold(
          backgroundColor: const Color(0xFFF8F4EC),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PalmLeafHeader(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    children: [
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.fromLTRB(16, 18, 28, 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.08),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Avatar + camera — upload works here
                              SizedBox(
                                width: 72,
                                height: 72,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Positioned.fill(
                                      child: GestureDetector(
                                        onTap: _picking
                                            ? null
                                            : _showPhotoSheet,
                                        child: ClipOval(
                                          child: ProfilePhoto(
                                            path: user?.photoPath,
                                            size: 72,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -2,
                                      bottom: -2,
                                      child: Material(
                                        color: AppColors.navy,
                                        shape: const CircleBorder(),
                                        elevation: 2,
                                        child: InkWell(
                                          customBorder:
                                              const CircleBorder(),
                                          onTap: _picking
                                              ? null
                                              : _showPhotoSheet,
                                          child: SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: Icon(
                                              _picking
                                                  ? Icons
                                                      .hourglass_top_rounded
                                                  : Icons
                                                      .photo_camera_outlined,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () =>
                                      AppNav.openEditProfile(context),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: AppFonts.playfair(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF123F4A),
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      _InfoLine(
                                        icon: Icons.mail_outline_rounded,
                                        text: email,
                                      ),
                                      const SizedBox(height: 4),
                                      _InfoLine(
                                        icon: Icons.place_outlined,
                                        text: city,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    AppNav.openEditProfile(context),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFFC9A227),
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _StatTile(
                              icon: const Icon(
                                Icons.place_outlined,
                                size: 22,
                                color: Color(0xFFC9A227),
                              ),
                              value: '12',
                              label: s.placesVisited,
                            ),
                            const SizedBox(width: 10),
                            _StatTile(
                              icon: const ParcoursPathIcon(
                                size: 22,
                                color: Color(0xFFC9A227),
                              ),
                              value: '3',
                              label: s.parcours,
                              onTap: () => context.go('/parcours'),
                            ),
                            const SizedBox(width: 10),
                            _StatTile(
                              icon: const Icon(
                                Icons.favorite_border_rounded,
                                size: 22,
                                color: Color(0xFFC9A227),
                              ),
                              value: '5',
                              label: s.favorites,
                              onTap: () =>
                                  AppNav.openFavorites(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(alpha: 0.07),
                                blurRadius: 16,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _MenuRow(
                                icon: Icons.favorite_border_rounded,
                                label: s.myFavorites,
                                onTap: () =>
                                    AppNav.openFavorites(context),
                              ),
                              const _Hairline(),
                              _MenuRow(
                                icon: Icons.map_outlined,
                                label: s.myParcours,
                                onTap: () => context.go('/parcours'),
                              ),
                              const _Hairline(),
                              _MenuRow(
                                icon: Icons.download_outlined,
                                label: s.myDownloads,
                                onTap: () {
                                  AppToast.info(
                                      context, s.downloadsSoon);
                                },
                              ),
                              const _Hairline(),
                              _MenuRow(
                                icon: Icons.settings_outlined,
                                label: s.settings,
                                onTap: () =>
                                    AppNav.openSettings(context),
                              ),
                              const _Hairline(),
                              _MenuRow(
                                icon: Icons.help_outline_rounded,
                                label: s.helpSupport,
                                onTap: () {
                                  AppToast.info(context, s.helpSoon);
                                },
                              ),
                              const _Hairline(),
                              _MenuRow(
                                icon: Icons.logout_rounded,
                                label: s.logout,
                                danger: true,
                                onTap: () => _confirmLogout(context, s),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context, AppStrings s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          s.logoutConfirmTitle,
          style: AppFonts.playfair(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF123F4A),
          ),
        ),
        content: Text(
          s.logoutConfirmBody,
          style: AppFonts.dmSans(
            fontSize: 14,
            color: const Color(0xFF5B6670),
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              s.cancel,
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5B6670),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              s.logout,
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF8B2E2E),
              ),
            ),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    AuthService.instance.logout();
    context.go('/login');
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.dmSans(
              fontSize: 13,
              color: const Color(0xFF6B7280),
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE6E2DA)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              icon,
              const SizedBox(height: 8),
              Text(
                value,
                style: AppFonts.playfair(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF123F4A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppFonts.dmSans(
                  fontSize: 12,
                  color: const Color(0xFF5B6670),
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      endIndent: 18,
      color: Color(0xFFE6E2DA),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
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
    final color = danger ? const Color(0xFF8B2E2E) : const Color(0xFF123F4A);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 24,
              color: danger
                  ? const Color(0xFF8B2E2E).withValues(alpha: 0.45)
                  : const Color(0xFFB0B8BF),
            ),
          ],
        ),
      ),
    );
  }
}
