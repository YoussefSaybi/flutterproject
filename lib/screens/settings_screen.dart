import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_controller.dart';
import '../navigation/app_nav.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/app_toast.dart';
import '../widgets/common_widgets.dart';

/// Paramètres — language selection (FR / EN / AR / ES / DE / PT).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = AppStrings.current;
        final current = LocaleController.instance.code;
        final options = [
          (code: 'FR', title: 'Français', subtitle: s.languageFrench),
          (code: 'EN', title: 'English', subtitle: s.languageEnglish),
          (code: 'ES', title: 'Español', subtitle: s.languageSpanish),
          (code: 'DE', title: 'Deutsch', subtitle: s.languageGerman),
          (code: 'PT', title: 'Português', subtitle: s.languagePortuguese),
          (code: 'TR', title: 'Türkçe', subtitle: s.languageTurkish),
          (code: 'AR', title: 'العربية', subtitle: s.languageArabic),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF8F4EC),
          body: Column(
            children: [
              PalmLeafHeader(
                child: Positioned(
                  top: MediaQuery.paddingOf(context).top + 10,
                  left: 12,
                  child: SoftCircleButton(
                    onPressed: () => AppNav.popOr(context, '/profile'),
                    icon: Icons.chevron_left_rounded,
                    background: Colors.white.withValues(alpha: 0.18),
                    foreground: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
                  children: [
                    Text(
                      s.settings,
                      style: AppFonts.playfair(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF123F4A),
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.settingsSubtitle,
                      style: AppFonts.dmSans(
                        fontSize: 14,
                        color: const Color(0xFF5B6670),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      s.language,
                      style: AppFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF175B68),
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < options.length; i++) ...[
                            if (i > 0)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 18,
                                endIndent: 18,
                                color: Color(0xFFE6E2DA),
                              ),
                            _LangOption(
                              code: options[i].code,
                              title: options[i].title,
                              subtitle: options[i].subtitle,
                              selected: current == options[i].code,
                              onTap: () async {
                                await LocaleController.instance
                                    .setCode(options[i].code);
                                if (!context.mounted) return;
                                AppToast.success(
                                  context,
                                  AppStrings.current.languageSelected,
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LangOption extends StatelessWidget {
  const _LangOption({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.gold.withValues(alpha: 0.18)
                    : const Color(0xFFF3F0E8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                code,
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: selected
                      ? const Color(0xFF8A6A12)
                      : const Color(0xFF123F4A),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF123F4A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppFonts.dmSans(
                      fontSize: 13,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.gold : Colors.transparent,
                border: Border.all(
                  color:
                      selected ? AppColors.gold : const Color(0xFFC5CBD0),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
