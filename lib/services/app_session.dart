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
    final email = _prefs?.getString(_kSessionEmail);
    if (email != null && email.isNotEmpty) {
      AuthService.instance.restoreSession(email);
    }
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
  /// Opening flow (not logged in): Home → Partenaires → 3 pages → Login.
  String nextRoute() {
    if (AuthService.instance.isLoggedIn) return '/home';
    return '/credits';
  }

  /// After partners flashscreen → always the 3 explain pages, then login.
  String routeAfterCredits() {
    return '/onboarding';
  }
}
