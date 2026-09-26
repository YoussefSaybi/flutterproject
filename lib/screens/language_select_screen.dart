import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_strings.dart';
import '../l10n/locale_controller.dart';
import '../services/app_session.dart';
import '../theme/app_assets.dart';
import '../theme/app_fonts.dart';
import '../widgets/auth_micro_interactions.dart';

/// First-launch language picker — auth look, compact, no scroll.
class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  static const _navy = Color(0xFF1B4A5A);
  static const _cream = Color(0xFFFAF7F0);

  late String _selected;

  static const _options = <({String code, String native})>[
    (code: 'FR', native: 'Français'),
    (code: 'EN', native: 'English'),
    (code: 'AR', native: 'العربية'),
    (code: 'ES', native: 'Español'),
    (code: 'DE', native: 'Deutsch'),
    (code: 'PT', native: 'Português'),
    (code: 'TR', native: 'Türkçe'),
  ];

  @override
  void initState() {
    super.initState();
    _selected = LocaleController.instance.code;
  }

  Future<void> _onSelect(String code) async {
    setState(() => _selected = code);
    await LocaleController.instance.setCode(code);
  }

  Future<void> _continue() async {
    await LocaleController.instance.setCode(_selected);
    await AppSession.instance.completeLanguage();
    if (!mounted) return;
    context.go(AppSession.instance.routeAfterLanguage());
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocaleController.instance,
      builder: (context, _) {
        final s = AppStrings.current;
        final topInset = MediaQuery.paddingOf(context).top;
        final bottomInset = MediaQuery.paddingOf(context).bottom;

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
                child: Padding(
                  padding: EdgeInsets.only(
                    top: topInset + 10,
                    bottom: bottomInset + 8,
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        AppAssets.logoGold,
                        height: 72,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppAssets.logo,
                          height: 72,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Text(
                                  s.chooseLanguageTitle,
                                  key: ValueKey(s.chooseLanguageTitle),
                                  textAlign: TextAlign.center,
                                  style: AppFonts.playfair(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: _navy,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                child: Text(
                                  s.chooseLanguageSubtitle,
                                  key: ValueKey(s.chooseLanguageSubtitle),
                                  textAlign: TextAlign.center,
                                  style: AppFonts.dmSans(
                                    fontSize: 13.5,
                                    color: const Color(0xFF6B7A80),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (var i = 0;
                                        i < _options.length;
                                        i++) ...[
                                      if (i > 0) const SizedBox(height: 8),
                                      Expanded(
                                        child: _AuthLangRow(
                                          code: _options[i].code,
                                          nativeName: _options[i].native,
                                          selected:
                                              _selected == _options[i].code,
                                          onTap: () =>
                                              _onSelect(_options[i].code),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              AuthPrimaryButton(
                                label: s.continueAction,
                                height: 52,
                                onPressed: _continue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AuthLangRow extends StatelessWidget {
  const _AuthLangRow({
    required this.code,
    required this.nativeName,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String nativeName;
  final bool selected;
  final VoidCallback onTap;

  static const _navy = Color(0xFF1B4A5A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: _navy.withValues(alpha: 0.06),
        highlightColor: _navy.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected
                ? _navy.withValues(alpha: 0.09)
                : Colors.white.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? _navy : _navy.withValues(alpha: 0.14),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? _navy
                      : _navy.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  code,
                  style: AppFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : _navy,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  nativeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.dmSans(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 160),
                opacity: selected ? 1 : 0,
                child: const Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: _navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
