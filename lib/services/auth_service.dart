import 'package:flutter/foundation.dart';

import '../utils/form_validators.dart';
import 'app_session.dart';

class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.password,
    this.phone = '',
    this.city = '',
    this.photoPath,
  });

  final String name;
  final String email;
  final String password;
  final String phone;
  final String city;
  /// Optional local asset or file path for the visitor profile photo.
  final String? photoPath;

  AppUser copyWith({
    String? name,
    String? email,
    String? password,
    String? phone,
    String? city,
    String? photoPath,
    bool clearPhoto = false,
  }) {
    return AppUser(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      photoPath: clearPhoto ? null : (photoPath ?? this.photoPath),
    );
  }
}

/// Local auth for demo flows (no backend yet).
class AuthService extends ChangeNotifier {
  AuthService._() {
    _users[_normalize(demoEmail)] = const AppUser(
      name: 'Emna El Abed',
      email: demoEmail,
      password: demoPassword,
      phone: '+216 24 349 288',
      city: 'Kerkennah, Sfax',
    );
  }

  static final AuthService instance = AuthService._();

  static const demoEmail = 'demo@ecoar.tn';
  static const demoPassword = 'demo1234';

  final Map<String, AppUser> _users = {};
  AppUser? _current;
  /// Profile photo lives independently of login so Accueil + Profil stay synced.
  String? _photoPath;

  AppUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  /// Shared avatar path for Accueil header + Profil card.
  String? get profilePhotoPath {
    final fromUser = _current?.photoPath;
    if (fromUser != null && fromUser.isNotEmpty) return fromUser;
    if (_photoPath != null && _photoPath!.isNotEmpty) return _photoPath;
    return null;
  }

  static String _normalize(String value) => value.trim().toLowerCase();

  static bool isValidEmail(String value) {
    return FormValidators.email(value) == null;
  }

  static bool isValidPhone(String value) {
    return FormValidators.phone(value) == null;
  }

  static bool isValidIdentifier(String value) =>
      FormValidators.loginIdentifier(value) == null;


  AuthResult login({
    required String identifier,
    required String password,
  }) {
    final idErr = FormValidators.loginIdentifier(identifier);
    if (idErr != null) return AuthResult.fail(idErr);
    final passErr = FormValidators.loginPassword(password);
    if (passErr != null) return AuthResult.fail(passErr);

    final id = identifier.trim();
    final pass = password;

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

    if (user != null && user.password == pass) {
      _current = user;
    } else if (user != null && user.password != pass) {
      // Demo: any valid password signs in the known account.
      _current = user.copyWith(password: pass);
      _users[_normalize(user.email)] = _current!;
    } else {
      // Demo: accept any well-formed identifier + password → open session.
      final isEmail = FormValidators.email(id) == null;
      final email = isEmail
          ? id
          : '${phoneDigits.isEmpty ? 'visiteur' : phoneDigits}@ecoar.tn';
      final nameFromEmail = email.split('@').first.replaceAll('.', ' ').trim();
      final displayName = nameFromEmail.isEmpty
          ? 'Visiteur'
          : nameFromEmail
              .split(RegExp(r'\s+'))
              .where((w) => w.isNotEmpty)
              .map((w) =>
                  '${w[0].toUpperCase()}${w.length > 1 ? w.substring(1) : ''}')
              .join(' ');
      _current = AppUser(
        name: displayName,
        email: email,
        password: pass,
        city: 'Kerkennah, Sfax',
        photoPath: _photoPath,
      );
      _users[_normalize(email)] = _current!;
    }

    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(_current!.email);
    return AuthResult.ok('Connexion réussie.');
  }

  AuthResult signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required bool acceptedTerms,
  }) {
    final nameErr = FormValidators.name(name);
    if (nameErr != null) return AuthResult.fail(nameErr);
    final emailErr = FormValidators.email(email);
    if (emailErr != null) return AuthResult.fail(emailErr);
    final passErr = FormValidators.password(password);
    if (passErr != null) return AuthResult.fail(passErr);
    final confirmErr =
        FormValidators.confirmPassword(confirmPassword, password);
    if (confirmErr != null) return AuthResult.fail(confirmErr);
    if (!acceptedTerms) {
      return AuthResult.fail('Veuillez accepter les conditions d\'utilisation.');
    }

    final e = email.trim();
    if (_users.containsKey(_normalize(e))) {
      return AuthResult.fail('Un compte existe déjà avec cet email.');
    }

    final user = AppUser(name: name.trim(), email: e, password: password);
    _users[_normalize(e)] = user;
    _current = user;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistSession(user.email);
    return AuthResult.ok('Compte créé avec succès.');
  }

  /// Demo reset codes keyed by normalized email (no real email send).
  final Map<String, String> _resetCodes = {};

  /// Request a password-reset code (demo: always "123456" if account exists).
  AuthResult requestPasswordReset({required String email}) {
    final emailErr = FormValidators.email(email);
    if (emailErr != null) return AuthResult.fail(emailErr);

    final key = _normalize(email);
    if (!_users.containsKey(key)) {
      // Same message either way to avoid account enumeration in UX copy,
      // but for demo we still only set a code when the user exists.
      return AuthResult.ok(
        'Si un compte existe pour cet email, un code de réinitialisation a été envoyé.',
      );
    }

    _resetCodes[key] = '123456';
    return AuthResult.ok(
      'Un code a été envoyé à ${email.trim()} (démo : 123456).',
    );
  }

  AuthResult resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) {
    final emailErr = FormValidators.email(email);
    if (emailErr != null) return AuthResult.fail(emailErr);

    final c = code.trim();
    if (c.isEmpty) return AuthResult.fail('Le code est requis.');
    if (!RegExp(r'^\d{6}$').hasMatch(c)) {
      return AuthResult.fail('Le code doit contenir 6 chiffres.');
    }

    final passErr = FormValidators.password(newPassword);
    if (passErr != null) return AuthResult.fail(passErr);
    final confirmErr =
        FormValidators.confirmPassword(confirmPassword, newPassword);
    if (confirmErr != null) return AuthResult.fail(confirmErr);

    final key = _normalize(email);
    final user = _users[key];
    if (user == null) {
      return AuthResult.fail('Aucun compte trouvé avec cet email.');
    }
    if (_resetCodes[key] != c) {
      return AuthResult.fail('Code incorrect ou expiré.');
    }

    _users[key] = user.copyWith(password: newPassword);
    _resetCodes.remove(key);
    notifyListeners();
    return AuthResult.ok('Mot de passe mis à jour. Vous pouvez vous connecter.');
  }

  AuthResult continueAsGuest({required String provider}) {
    final email = provider == 'apple'
        ? 'apple@ecoar.tn'
        : 'emna.el.abed.dev@gmail.com';
    _current = AppUser(
      name: provider == 'apple' ? 'Utilisateur Apple' : 'Emna El Abed',
      email: email,
      password: '',
      city: provider == 'apple' ? '' : 'Kerkennah, Sfax',
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
    } else if (key == 'google@ecoar.tn' ||
        key == 'emna.el.abed.dev@gmail.com') {
      _current = const AppUser(
        name: 'Emna El Abed',
        email: 'emna.el.abed.dev@gmail.com',
        password: '',
        city: 'Kerkennah, Sfax',
      );
      _users[_normalize(_current!.email)] = _current!;
    } else {
      _current = AppUser(
        name: email.split('@').first,
        email: email,
        password: '',
      );
      _users[key] = _current!;
    }
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      _current = _current!.copyWith(photoPath: _photoPath);
      _users[_normalize(_current!.email)] = _current!;
    }
    notifyListeners();
  }

  /// Apply persisted avatar (works even when not logged in).
  void restoreProfilePhoto(String? path) {
    _photoPath = (path != null && path.isNotEmpty) ? path : null;
    if (_photoPath != null && _current != null) {
      _current = _current!.copyWith(photoPath: _photoPath);
      _users[_normalize(_current!.email)] = _current!;
    }
    notifyListeners();
  }

  /// Set / clear profile photo — Accueil + Profil update together.
  void setProfilePhoto(String? path, {bool clear = false}) {
    if (clear) {
      _photoPath = null;
      if (_current != null) {
        _current = _current!.copyWith(clearPhoto: true);
        _users[_normalize(_current!.email)] = _current!;
      }
    } else if (path != null && path.isNotEmpty) {
      _photoPath = path;
      if (_current != null) {
        _current = _current!.copyWith(photoPath: path);
        _users[_normalize(_current!.email)] = _current!;
      }
    }
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.persistProfilePhoto(_photoPath);
  }

  void logout() {
    _current = null;
    notifyListeners();
    // ignore: unawaited_futures
    AppSession.instance.clearSession();
  }

  /// Clears in-memory user without touching prefs (used by intro reset).
  void logoutLocalOnly() {
    _current = null;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? photoPath,
    bool clearPhoto = false,
  }) {
    if (clearPhoto || photoPath != null) {
      setProfilePhoto(photoPath, clear: clearPhoto);
    }

    final cur = _current;
    if (cur == null) return;
    if (name == null && email == null && phone == null && city == null) {
      return;
    }
    final updated = cur.copyWith(
      name: name,
      email: email,
      phone: phone,
      city: city,
      photoPath: profilePhotoPath,
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
