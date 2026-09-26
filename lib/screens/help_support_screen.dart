import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Aide & support — about EcoAR Kerkennah + SAWN partners.
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _paragraphs = <String>[
    'EcoAR Kerkennah est une application de valorisation numérique '
        'multilingue du patrimoine de Kerkennah, portée par Méliès '
        'Production Technologies.',
    'Elle propose une découverte interactive du patrimoine culturel '
        'des îles à travers des parcours, des contenus multimédias, '
        'des témoignages, des archives et des expériences numériques '
        'accessibles à différents publics.',
    'L’application est réalisée dans le cadre du projet SAWN, projet '
        'de coopération sur les enjeux de préservation du patrimoine '
        'en Tunisie.',
    'Le projet SAWN est mis en œuvre par le Service de Coopération et '
        'd’Action Culturelle (SCAC) de l’Ambassade de France en Tunisie '
        'et l’Institut français de Tunisie, avec le soutien du Fonds '
        'Équipe France (FEF) du ministère de l’Europe et des Affaires '
        'étrangères.',
    'SAWN vise notamment à soutenir des initiatives innovantes de '
        'valorisation du patrimoine, à encourager l’utilisation de '
        'technologies et d’approches créatives dans le champ patrimonial '
        'et à favoriser des solutions contribuant à la préservation du '
        'patrimoine culturel et à son accessibilité auprès de différents '
        'publics.',
    'À travers EcoAR Kerkennah, l’objectif est de contribuer à la '
        'préservation, à la valorisation et à la transmission du '
        'patrimoine matériel et immatériel de Kerkennah, tout en le '
        'rendant plus accessible aux habitants, aux nouvelles '
        'générations et aux visiteurs.',
  ];

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.current;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      body: Column(
        children: [
          PalmLeafHeader(
            child: Positioned(
              top: MediaQuery.paddingOf(context).top + 10,
              left: 12,
              child: SoftCircleButton(
                onPressed: () => AppNav.popOr(context, '/profile'),
                icon: Icons.arrow_back_ios_new_rounded,
                background: Colors.white.withValues(alpha: 0.18),
                foreground: Colors.white,
                size: 40,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(22, 24, 22, 28 + bottom),
              children: [
                Text(
                  s.helpSupport,
                  style: AppFonts.playfair(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF123F4A),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'À propos du projet',
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    color: const Color(0xFF5B6670),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _paragraphs.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        Text(
                          _paragraphs[i],
                          style: AppFonts.dmSans(
                            fontSize: 14.5,
                            color: const Color(0xFF2A3A40),
                            height: 1.55,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const _PartnerLogos(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerLogos extends StatelessWidget {
  const _PartnerLogos();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _LogoTile(
                  asset: AppAssets.helpLogoAmbassade,
                  height: 72,
                  label: 'Ambassade de France',
                ),
              ),
              _VRule(),
              Expanded(
                child: _LogoTile(
                  asset: AppAssets.helpLogoIft,
                  height: 58,
                  label: 'Institut Français Tunisie',
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              height: 1,
              color: const Color(0xFFE6E2DA),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _LogoTile(
                  asset: AppAssets.helpLogoSawn,
                  height: 70,
                  label: 'SAWN',
                ),
              ),
              _VRule(),
              Expanded(
                child: _LogoTile(
                  asset: AppAssets.helpLogoMelies,
                  height: 48,
                  label: 'Méliès',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VRule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 1,
        height: 64,
        color: const Color(0xFFE6E2DA),
      ),
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile({
    required this.asset,
    required this.height,
    required this.label,
  });

  final String asset;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      image: true,
      child: Center(
        child: Image.asset(
          asset,
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (_, __, ___) => Text(
            label,
            textAlign: TextAlign.center,
            style: AppFonts.dmSans(
              fontSize: 11,
              color: AppColors.navy,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
