import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ArLightScreen extends StatelessWidget {
  const ArLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bgBoat, fit: BoxFit.cover),
          Positioned(
            top: top + 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                SoftCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  background: Colors.black.withValues(alpha: 0.35),
                  foreground: Colors.white,
                  onPressed: () => AppNav.popOr(context, '/scanner'),
                ),
                const Expanded(child: EcoLogo(compact: true, height: 40)),
                SoftCircleButton(
                  icon: Icons.menu,
                  background: Colors.black.withValues(alpha: 0.35),
                  foreground: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment(0, -0.15),
            child: PackIcon(AppAssets.iconPinGold, size: 56),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 100 + bottom,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => AppNav.popOr(context, '/scanner'),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                  Text(
                    'Charfiya traditionnelle',
                    style: AppFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Embarcation emblématique de Kerkennah, utilisée par les pêcheurs depuis des générations.',
                    style: AppFonts.dmSans(color: Colors.white70, height: 1.35, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _Tag(icon: Icons.anchor, label: 'Patrimoine maritime'),
                      _Tag(icon: Icons.handshake_outlined, label: 'Savoir-faire local'),
                      _Tag(icon: Icons.place_outlined, label: 'Île Chergui'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => AppNav.openAudio(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                      ),
                      icon: const Icon(Icons.graphic_eq),
                      label: Text(
                        "Écouter l'histoire",
                        style: AppFonts.dmSans(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 16 + bottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _BottomAction(
                  icon: Icons.map_outlined,
                  label: 'Carte',
                  onTap: () => AppNav.goMap(context),
                ),
                _BottomAction(
                  icon: Icons.qr_code_scanner,
                  label: 'Scanner',
                  highlight: true,
                  onTap: () => AppNav.goScanner(context),
                ),
                _BottomAction(
                  icon: Icons.more_vert,
                  label: 'À propos',
                  onTap: () => AppNav.goProfile(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: AppFonts.dmSans(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: highlight ? 58 : 48,
            height: highlight ? 58 : 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight
                  ? const Color(0xFF4FC3F7).withValues(alpha: 0.35)
                  : Colors.black.withValues(alpha: 0.45),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppFonts.dmSans(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
