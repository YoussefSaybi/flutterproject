import 'package:flutter/foundation.dart';

import 'app_session.dart';

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    this.phone = '',
    this.city = '',
  });

  final String name;
  final String email;
  final String password;
  final String phone;
  final String city;

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? city,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      city: city ?? this.city,
    );
  }
}

/// Local auth for demo flows (no backend yet).
class AuthService extends ChangeNotifier {
  AuthService._() {
    _users[_normalize(demoEmail)] = const AppUser(
      name: 'Mohamed Azmi',
      email: demoEmail,
      password: demoPassword,
      phone: '+216 24 349 288',
      city: 'Sfax, Tunisie',
    );
  }

  static final AuthService instance = AuthService._();

  static const demoEmail = 'demo@ecoar.tn';
  static const demoPassword = 'demo1234';

  final Map<String, AppUser> _users = {};
  AppUser? _current;

  AppUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  static String _normalize(String value) => value.trim().toLowerCase();

  static bool isValidEmail(String value) {
    final v = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  }

  static bool isValidPhone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8;
  }

  static bool isValidIdentifier(String value) =>
      isValidEmail(value) || isValidPhone(value);

  AuthResult login({
    required String identifier,
    required String password,
  }) {
    final id = identifier.trim();
    final pass = password;

    if (id.isEmpty || pass.isEmpty) {
      return AuthResult.fail('Veuillez remplir email/téléphone et mot de passe.');
    }
    if (!isValidIdentifier(id)) {
      return AuthResult.fail('Email ou numéro de téléphone invalide.');
    }
    if (pass.length < 6) {
      return AuthResult.fail('Le mot de passe doit contenir au moins 6 caractères.');
    }

    final phoneDigits = id.replaceAll(RegExp(r'\D'), '');
    AppUser? user = _users[_normalize(id)];
    if (user == null) {
      for (final u in _users.values) {
        final sameEmail = u.email.toLowerCase() == id.toLowerCase();
        final samePhone = u.phone.isNotEmpty &&
            u.phone.replaceAll(RegExp(r'\D'), '') == phoneDigits;
        if (sameEmail || samePhone) {
          user = u;
          break;
        }
      }
    }

    if (user == null || user.password != pass) {
      return AuthResult.fail('Identifiants incorrects.');
    }

    _current = user;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(user.email);
    return AuthResult.ok('Connexion réussie.');
  }

  AuthResult signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    final n = name.trim();
    final e = email.trim();

    if (n.isEmpty || e.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return AuthResult.fail('Veuillez remplir tous les champs.');
    }
    if (n.length < 2) {
      return AuthResult.fail('Nom complet trop court.');
    }
    if (!isValidEmail(e)) {
      return AuthResult.fail('Adresse email invalide.');
    }
    if (password.length < 8) {
      return AuthResult.fail('Le mot de passe doit contenir au moins 8 caractères.');
    }
    if (password != confirmPassword) {
      return AuthResult.fail('Les mots de passe ne correspondent pas.');
    }
    if (!acceptedTerms) {
      return AuthResult.fail('Veuillez accepter les conditions d\'utilisation.');
    }
    if (_users.containsKey(_normalize(e))) {
      return AuthResult.fail('Un compte existe déjà avec cet email.');
    }

    final user = AppUser(name: n, email: e, password: password);
    _users[_normalize(e)] = user;
    _current = user;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(user.email);
    return AuthResult.ok('Compte créé avec succès.');
  }

  AuthResult continueAsGuest({required String provider}) {
    final email =
        provider == 'apple' ? 'apple@ecoar.tn' : 'google@ecoar.tn';
    _current = AppUser(
      name: provider == 'apple' ? 'Utilisateur Apple' : 'Utilisateur Google',
      email: email,
      password: '',
    );
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(email);
    return AuthResult.ok('Connecté avec $provider.');
  }

  /// Restore in-memory session after prefs load (splash bootstrap).
  void restoreSession(String email) {
    final key = _normalize(email);
    final user = _users[key];
    if (user != null) {
      _current = user;
    } else {
      _current = AppUser(
        name: email.split('@').first,
        email: email,
        password: '',
      );
      _users[key] = _current!;
    }
    notifyListeners();
  }

  void logout() {
    _current = null;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.clearSession();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? city,
  }) {
    final cur = _current;
    if (cur == null) return;
    final updated = cur.copyWith(
      name: name,
      email: email,
      phone: phone,
      city: city,
    );
    _users.remove(_normalize(cur.email));
    _users[_normalize(updated.email)] = updated;
    _current = updated;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(updated.email);
  }
}

class AuthResult {
  const AuthResult._({required this.success, required this.message});

  factory AuthResult.ok(String message) =>
      AuthResult._(success: true, message: message);
  factory AuthResult.fail(String message) =>
      AuthResult._(success: false, message: message);

  final bool success;
  final String message;
}
