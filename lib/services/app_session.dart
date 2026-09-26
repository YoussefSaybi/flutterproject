import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

/// Local launch state: onboarding flag + restored session (no network).
class AppSession {
  AppSession._();
  static final AppSession instance = AppSession._();

  static const _kOnboarding = 'ecoar_onboarding_complete';
  static const _kCredits = 'ecoar_credits_seen';
  static const _kLanguage = 'ecoar_lang_chosen';
  static const _kSessionEmail = 'ecoar_session_email';
  static const _kPhotoPath = 'ecoar_profile_photo';

  SharedPreferences? _prefs;
  bool _ready = false;

  bool get isReady => _ready;
  bool get hasSeenOnboarding =>
      _prefs?.getBool(_kOnboarding) ?? false;
  bool get hasSeenCredits =>
      _prefs?.getBool(_kCredits) ?? false;
  bool get hasChosenLanguage =>
      _prefs?.getBool(_kLanguage) ?? false;
  String? get profilePhotoPath {
    final p = _prefs?.getString(_kPhotoPath);
    if (p == null || p.isEmpty) return null;
    return p;
  }

  Future<void> init() async {
    if (_ready) return;
    _prefs = await SharedPreferences.getInstance();
    _ready = true;

    // While building the demo, always replay the full intro on cold start:
    // Language → Splash → Partenaires → Onboarding (×3) → Home.
    // Auth (login / signup) opens from Favoris / Enregistrement only.
    // Remove this block when you want “stay logged in” between launches.
    if (kDebugMode) {
      await resetIntroFlow();
      AuthService.instance.restoreProfilePhoto(profilePhotoPath);
      return;
    }

    final email = _prefs?.getString(_kSessionEmail);
    if (email != null && email.isNotEmpty) {
      AuthService.instance.restoreSession(email);
    }
    AuthService.instance.restoreProfilePhoto(profilePhotoPath);
  }

  /// Clears partners / onboarding / language flags and saved login (debug intro replay).
  /// Keeps the profile photo so Accueil / Profil stay in sync across relaunches.
  Future<void> resetIntroFlow() async {
    await _prefs?.remove(_kOnboarding);
    await _prefs?.remove(_kCredits);
    await _prefs?.remove(_kLanguage);
    await _prefs?.remove(_kSessionEmail);
    AuthService.instance.logoutLocalOnly();
  }

  Future<void> completeOnboarding() async {
    await _prefs?.setBool(_kOnboarding, true);
  }

  Future<void> completeCredits() async {
    await _prefs?.setBool(_kCredits, true);
  }

  Future<void> completeLanguage() async {
    await _prefs?.setBool(_kLanguage, true);
  }

  Future<void> persistSession(String email) async {
    await _prefs?.setString(_kSessionEmail, email.trim().toLowerCase());
  }

  Future<void> clearSession() async {
    await _prefs?.remove(_kSessionEmail);
  }

  Future<void> persistProfilePhoto(String? path) async {
    if (path == null || path.isEmpty) {
      await _prefs?.remove(_kPhotoPath);
    } else {
      await _prefs?.setString(_kPhotoPath, path);
    }
  }

  /// First destination when the app opens.
  /// Opening flow: Language → Splash → Partenaires → Onboarding → Home.
  /// Login / signup open only when the user taps Favoris or Enregistrement.
  String initialRoute() {
    if (AuthService.instance.isLoggedIn) return '/home';
    if (!hasChosenLanguage) return '/language';
    return '/';
  }

  /// Splash destination after brand display.
  String nextRoute() {
    if (AuthService.instance.isLoggedIn) return '/home';
    if (!hasSeenCredits) return '/credits';
    if (!hasSeenOnboarding) return '/onboarding';
    return '/home';
  }

  /// After language selection → brand splash, then partners.
  String routeAfterLanguage() {
    return '/';
  }

  /// After partners flashscreen → the 3 explain pages, then home.
  String routeAfterCredits() {
    return '/onboarding';
  }
}
