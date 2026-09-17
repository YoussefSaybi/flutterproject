import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _filter = 'tous';
  String _lang = 'FR';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final items = MockData.favorites.where((f) {
      if (_filter == 'tous') return true;
      return f.type == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, top + 8, 12, 18),
            color: AppColors.navy,
            child: Row(
              children: [
                SoftCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  background: Colors.transparent,
                  foreground: AppColors.white,
                  onPressed: () => AppNav.popOr(context, '/profile'),
                ),
                const Expanded(child: EcoLogo(compact: true, height: 40)),
                LanguageSwitcher(
                  selected: _lang,
                  onChanged: (v) => setState(() => _lang = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              children: [
                Text(
                  'Mes favoris',
                  style: AppFonts.playfair(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vos lieux, parcours et histoires préférés à retrouver à tout moment.',
                  style: AppFonts.dmSans(color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _Chip(
                        label: 'Tous',
                        selected: _filter == 'tous',
                        onTap: () => setState(() => _filter = 'tous'),
                      ),
                      _Chip(
                        label: 'Lieux',
                        icon: Icons.place_outlined,
                        selected: _filter == 'lieux',
                        onTap: () => setState(() => _filter = 'lieux'),
                      ),
                      _Chip(
                        label: 'Parcours',
                        icon: Icons.route_outlined,
                        selected: _filter == 'parcours',
                        onTap: () => setState(() => _filter = 'parcours'),
                      ),
                      _Chip(
                        label: 'Récits',
                        icon: Icons.menu_book_outlined,
                        selected: _filter == 'recits',
                        onTap: () => setState(() => _filter = 'recits'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Aucun favori dans cette catégorie.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(color: AppColors.textSecondary),
                    ),
                  ),
                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        if (item.type == 'parcours') {
                          AppNav.openParcoursDetail(context);
                        } else if (item.type == 'recit') {
                          AppNav.openAudio(context);
                        } else {
                          AppNav.openAr(context);
                        }
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item.imageAsset,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: AppFonts.playfair(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                  Text(
                                    item.category,
                                    style: AppFonts.dmSans(color: AppColors.teal, fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.place_outlined, size: 14, color: AppColors.teal),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.location,
                                        style: AppFonts.dmSans(color: AppColors.teal, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.favorite, color: AppColors.gold),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.navy.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: selected ? AppColors.white : AppColors.navy),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppFonts.dmSans(
                  color: selected ? AppColors.white : AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
