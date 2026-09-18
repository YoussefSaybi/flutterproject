import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
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

  @override
  Widget build(BuildContext context) {
    final items = MockData.favorites.where((f) {
      if (_filter == 'tous') return true;
      return f.type == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          TealHeader(
            showBack: true,
            showLanguage: true,
            onBack: () => AppNav.popOr(context, '/profile'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
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
                  style: AppFonts.dmSans(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterPill(
                        label: 'Tous',
                        selected: _filter == 'tous',
                        onTap: () => setState(() => _filter = 'tous'),
                      ),
                      _FilterPill(
                        label: 'Lieux',
                        selected: _filter == 'lieux',
                        onTap: () => setState(() => _filter = 'lieux'),
                      ),
                      _FilterPill(
                        label: 'Parcours',
                        selected: _filter == 'parcours',
                        onTap: () => setState(() => _filter = 'parcours'),
                      ),
                      _FilterPill(
                        label: 'Récits',
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
                        } else if (item.type == 'recits') {
                          AppNav.openAudio(context);
                        } else {
                          AppNav.openAr(context);
                        }
                      },
                      borderRadius:
                          BorderRadius.circular(AppLayout.radiusMedium),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.circular(AppLayout.radiusMedium),
                          boxShadow: AppLayout.softShadow,
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
                                  const SizedBox(height: 2),
                                  Text(
                                    item.category,
                                    style: AppFonts.dmSans(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.place_outlined,
                                        size: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          item.location,
                                          style: AppFonts.dmSans(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const PackIcon(
                              AppAssets.iconHeartActive,
                              size: 22,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.navy,
                            ),
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

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppLayout.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : AppColors.white,
            borderRadius: BorderRadius.circular(AppLayout.radiusPill),
            border: Border.all(
              color: selected
                  ? AppColors.navy
                  : AppColors.navy.withValues(alpha: 0.28),
            ),
          ),
          child: Text(
            label,
            style: AppFonts.dmSans(
              color: selected ? AppColors.white : AppColors.navy,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
