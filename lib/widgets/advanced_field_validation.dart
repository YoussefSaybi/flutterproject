import 'package:flutter/material.dart';

import '../theme/app_fonts.dart';
import '../utils/form_validators.dart';

/// Live rule checklist for advanced input validation (contrôle de saisie).
class ValidationRulesPanel extends StatelessWidget {
  const ValidationRulesPanel({
    super.key,
    required this.title,
    required this.rules,
  });

  final String title;
  final List<ValidationRule> rules;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD8E3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B4A5A),
            ),
          ),
          const SizedBox(height: 8),
          ...rules.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: r.ok
                            ? const Color(0xFF2F7A4A)
                            : Colors.transparent,
                        border: Border.all(
                          color: r.ok
                              ? const Color(0xFF2F7A4A)
                              : const Color(0xFF9AA8AE),
                          width: 1.4,
                        ),
                      ),
                      child: r.ok
                          ? const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.label,
                        style: AppFonts.dmSans(
                          fontSize: 12,
                          color: r.ok
                              ? const Color(0xFF2F7A4A)
                              : const Color(0xFF5B6670),
                          fontWeight:
                              r.ok ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class ValidationRule {
  const ValidationRule({required this.label, required this.ok});
  final String label;
  final bool ok;
}

/// Password strength meter + label.
class PasswordStrengthMeter extends StatelessWidget {
  const PasswordStrengthMeter({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final score = FormValidators.passwordStrength(password);
    const colors = [
      Color(0xFF8B2E2E),
      Color(0xFFC97B3A),
      Color(0xFFC9A05C),
      Color(0xFF2F7A4A),
      Color(0xFF1B6B3A),
    ];
    final color = colors[score.clamp(0, 4)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            final filled = i < score;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: 5,
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: filled ? color : const Color(0xFFD8E3E8),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Force : ${FormValidators.passwordStrengthLabel(score)}',
          style: AppFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Builds password rule list for signup.
List<ValidationRule> passwordRules(String value) {
  return [
    ValidationRule(label: 'Au moins 8 caractères', ok: value.length >= 8),
    ValidationRule(
      label: 'Une majuscule (A–Z)',
      ok: RegExp(r'[A-Z]').hasMatch(value),
    ),
    ValidationRule(
      label: 'Une minuscule (a–z)',
      ok: RegExp(r'[a-z]').hasMatch(value),
    ),
    ValidationRule(
      label: 'Un chiffre (0–9)',
      ok: RegExp(r'\d').hasMatch(value),
    ),
    ValidationRule(
      label: 'Un caractère spécial (!@#…)',
      ok: RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\;/`]').hasMatch(value),
    ),
  ];
}

List<ValidationRule> nameRules(String value) {
  final v = value.trim();
  final parts = v.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  return [
    ValidationRule(label: 'Au moins 3 caractères', ok: v.length >= 3),
    ValidationRule(
      label: 'Prénom et nom',
      ok: parts.length >= 2,
    ),
    ValidationRule(
      label: 'Sans chiffres',
      ok: v.isNotEmpty && !RegExp(r'\d').hasMatch(v),
    ),
  ];
}

List<ValidationRule> emailRules(String value) {
  final v = value.trim();
  return [
    ValidationRule(label: 'Non vide', ok: v.isNotEmpty),
    ValidationRule(label: 'Contient @', ok: v.contains('@')),
    ValidationRule(
      label: 'Format email valide',
      ok: FormValidators.email(v) == null,
    ),
  ];
}

List<ValidationRule> loginIdentifierRules(String value) {
  final v = value.trim();
  if (v.contains('@') || v.isEmpty) {
    return [
      ValidationRule(label: 'Champ renseigné', ok: v.isNotEmpty),
      ValidationRule(
        label: 'Email valide ou téléphone',
        ok: FormValidators.loginIdentifier(v) == null,
      ),
    ];
  }
  final digits = v.replaceAll(RegExp(r'\D'), '');
  return [
    ValidationRule(label: 'Champ renseigné', ok: v.isNotEmpty),
    ValidationRule(
      label: '8 chiffres (TN) ou +216…',
      ok: FormValidators.phone(v) == null,
    ),
    ValidationRule(
      label: 'Uniquement chiffres / +',
      ok: digits.length >= 8,
    ),
  ];
}

List<ValidationRule> loginPasswordRules(String value) {
  return [
    ValidationRule(label: 'Mot de passe renseigné', ok: value.isNotEmpty),
    ValidationRule(label: 'Au moins 6 caractères', ok: value.length >= 6),
  ];
}

List<ValidationRule> confirmPasswordRules(String value, String password) {
  return [
    ValidationRule(label: 'Confirmation renseignée', ok: value.isNotEmpty),
    ValidationRule(
      label: 'Identique au mot de passe',
      ok: value.isNotEmpty && value == password,
    ),
  ];
}
