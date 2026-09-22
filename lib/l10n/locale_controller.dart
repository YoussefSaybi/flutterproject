import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide language codes (AR / FR / EN / ES / DE / PT / TR).
enum AppLang {
  ar('AR', 'ar'),
  fr('FR', 'fr'),
  en('EN', 'en'),
  es('ES', 'es'),
  de('DE', 'de'),
  pt('PT', 'pt'),
  tr('TR', 'tr');

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
      case 'ES':
        return AppLang.es;
      case 'DE':
        return AppLang.de;
      case 'PT':
        return AppLang.pt;
      case 'TR':
        return AppLang.tr;
      default:
        return AppLang.fr;
    }
  }
}

/// Notifies the whole app when language changes (RTL for Arabic).
class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  static const _prefsKey = 'ecoar_lang';

  AppLang _lang = AppLang.fr;
  AppLang get lang => _lang;
  String get code => _lang.code;
  Locale get locale => _lang.locale;
  TextDirection get textDirection =>
      _lang.isRtl ? TextDirection.rtl : TextDirection.ltr;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved == null) return;
    final next = AppLang.fromCode(saved);
    if (next == _lang) return;
    _lang = next;
    notifyListeners();
  }

  Future<void> setCode(String code) async {
    final next = AppLang.fromCode(code);
    if (next == _lang) return;
    _lang = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, next.code);
  }
}
