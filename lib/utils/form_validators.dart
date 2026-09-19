/// Shared advanced form validation for EcoAR login / signup (French messages).
class FormValidators {
  FormValidators._();

  static final _emailRe = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  /// Letters (incl. accents), spaces, hyphen, apostrophe — at least 2 words preferred.
  static final _nameRe = RegExp(
    r"^[A-Za-zÀ-ÖØ-öø-ÿĀ-žḀ-ỿ][A-Za-zÀ-ÖØ-öø-ÿĀ-žḀ-ỿ' -]{1,78}$",
  );

  static String? name(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Le nom complet est requis.';
    if (v.length < 3) return 'Le nom doit contenir au moins 3 caractères.';
    if (v.length > 80) return 'Le nom est trop long (80 caractères max).';
    if (RegExp(r'\d').hasMatch(v)) {
      return 'Le nom ne doit pas contenir de chiffres.';
    }
    if (!_nameRe.hasMatch(v)) {
      return 'Utilisez uniquement des lettres, espaces ou tirets.';
    }
    final parts = v.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length < 2) {
      return 'Indiquez le prénom et le nom.';
    }
    return null;
  }

  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "L'adresse email est requise.";
    if (v.length > 120) return 'Email trop long.';
    if (v.contains(' ')) return "L'email ne doit pas contenir d'espaces.";
    if (!_emailRe.hasMatch(v)) return 'Adresse email invalide.';
    return null;
  }

  /// Email or Tunisian / international phone.
  static String? loginIdentifier(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email ou numéro de téléphone requis.';
    if (v.contains('@')) return email(v);
    return phone(v);
  }

  static String? phone(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Le numéro de téléphone est requis.';
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    // Tunisia: 8 digits local, or 216 + 8
    if (digits.length == 8 && RegExp(r'^[2-9]\d{7}$').hasMatch(digits)) {
      return null;
    }
    if (digits.length == 11 && digits.startsWith('216')) {
      final local = digits.substring(3);
      if (RegExp(r'^[2-9]\d{7}$').hasMatch(local)) return null;
    }
    // International: 10–15 digits
    if (digits.length >= 10 && digits.length <= 15) return null;
    return 'Numéro invalide (ex. 24 349 288 ou +216…).';
  }

  static String? password(
    String? value, {
    int minLength = 8,
    bool requireStrength = true,
  }) {
    final v = value ?? '';
    if (v.isEmpty) return 'Le mot de passe est requis.';
    if (v.length < minLength) {
      return 'Au moins $minLength caractères.';
    }
    if (v.length > 64) return 'Mot de passe trop long (64 max).';
    if (requireStrength) {
      if (!RegExp(r'[A-Z]').hasMatch(v)) {
        return 'Ajoutez au moins une majuscule.';
      }
      if (!RegExp(r'[a-z]').hasMatch(v)) {
        return 'Ajoutez au moins une minuscule.';
      }
      if (!RegExp(r'\d').hasMatch(v)) {
        return 'Ajoutez au moins un chiffre.';
      }
      if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`]').hasMatch(v)) {
        return 'Ajoutez un caractère spécial (!@#…).';
      }
    }
    return null;
  }

  /// Login: slightly lighter password rules (demo accounts stay usable).
  static String? loginPassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Le mot de passe est requis.';
    if (v.length < 6) return 'Au moins 6 caractères.';
    if (v.length > 64) return 'Mot de passe trop long (64 max).';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    final v = value ?? '';
    if (v.isEmpty) return 'Confirmez le mot de passe.';
    if (v != password) return 'Les mots de passe ne correspondent pas.';
    return null;
  }

  /// 0–4 strength score for UI meter.
  static int passwordStrength(String value) {
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[a-z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`]').hasMatch(value)) {
      score++;
    }
    if (value.length >= 12) score = (score + 1).clamp(0, 4);
    return score.clamp(0, 4);
  }

  static String passwordStrengthLabel(int score) {
    switch (score) {
      case 0:
      case 1:
        return 'Faible';
      case 2:
        return 'Moyen';
      case 3:
        return 'Fort';
      default:
        return 'Très fort';
    }
  }
}
