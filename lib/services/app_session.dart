import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

/// Local launch state: onboarding flag + restored session (no network).
class AppSession {
  AppSession._();
  static final AppSession instance = AppSession._();

  static const _kOnboarding = 'ecoar_onboarding_complete';
  static const _kCredits = 'ecoar_credits_seen';
  static const _kSessionEmail = 'ecoar_session_email';

  SharedPreferences? _prefs;
  bool _ready = false;

  bool get isReady => _ready;
  bool get hasSeenOnboarding =>
      _prefs?.getBool(_kOnboarding) ?? false;
  bool get hasSeenCredits =>
      _prefs?.getBool(_kCredits) ?? false;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _ready = true;

    // While building the demo, always replay the full intro on cold start:
    // Splash → Partenaires → Onboarding (×3) → Login → Home.
    // Remove this block when you want “stay logged in” between launches.
    if (kDebugMode) {
      await resetIntroFlow();
      return;
    }

    final email = _prefs?.getString(_kSessionEmail);
    if (email != null && email.isNotEmpty) {
      AuthService.instance.restoreSession(email);
    }
  }

  /// Clears partners / onboarding flags and saved login (debug intro replay).
  Future<void> resetIntroFlow() async {
    await _prefs?.remove(_kOnboarding);
    await _prefs?.remove(_kCredits);
    await _prefs?.remove(_kSessionEmail);
    AuthService.instance.logoutLocalOnly();
  }

  Future<void> completeOnboarding() async {
    await _prefs?.setBool(_kOnboarding, true);
  }

  Future<void> completeCredits() async {
    await _prefs?.setBool(_kCredits, true);
  }

  Future<void> persistSession(String email) async {
    await _prefs?.setString(_kSessionEmail, email.trim().toLowerCase());
  }

  Future<void> clearSession() async {
    await _prefs?.remove(_kSessionEmail);
  }

  /// Splash destination after brand display.
  /// Opening flow: Splash → Partenaires → Onboarding → Login → Home.
  String nextRoute() {
    if (AuthService.instance.isLoggedIn) return '/home';
    if (!hasSeenCredits) return '/credits';
    if (!hasSeenOnboarding) return '/onboarding';
    return '/login';
  }

  /// After partners flashscreen → always the 3 explain pages, then login.
  String routeAfterCredits() {
    return '/onboarding';
  }
}
