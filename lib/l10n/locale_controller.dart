import 'package:flutter/material.dart';

/// App-wide language codes matching the LanguageSwitcher (AR / FR / EN).
enum AppLang {
  ar('AR', 'ar'),
  fr('FR', 'fr'),
  en('EN', 'en');

  const AppLang(this.code, this.localeCode);
  final String code;
  final String localeCode;

  Locale get locale => Locale(localeCode);
  bool get isRtl => this == AppLang.ar;

  static AppLang fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'AR':
        return AppLang.ar;
      case 'EN':
        return AppLang.en;
      default:
        return AppLang.fr;
    }
  }
}

/// Notifies the whole app when language changes (RTL for Arabic).
class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  AppLang _lang = AppLang.fr;
  AppLang get lang => _lang;
  String get code => _lang.code;
  Locale get locale => _lang.locale;
  TextDirection get textDirection =>
      _lang.isRtl ? TextDirection.rtl : TextDirection.ltr;

  void setCode(String code) {
    final next = AppLang.fromCode(code);
    if (next == _lang) return;
    _lang = next;
    notifyListeners();
  }
}
