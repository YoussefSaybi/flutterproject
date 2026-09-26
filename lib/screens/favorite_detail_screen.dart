import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Favorite place / parcours / récit detail — hero photo + fiche.
class FavoriteDetailScreen extends StatefulWidget {
  const FavoriteDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<FavoriteDetailScreen> createState() => _FavoriteDetailScreenState();
}

class _FavoriteDetailScreenState extends State<FavoriteDetailScreen> {
  bool _isFavorite = true;

  FavoriteItem get _item => MockData.favorites.firstWhere(
        (f) => f.id == widget.id,
        orElse: () => MockData.favorites.first,
      );

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      item.imageAsset,
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 320,
                        color: const Color(0xFF123F4A),
                      ),
                    ),
                    Positioned(
                      top: top + 8,
                      left: 12,
                      child: SoftCircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () => AppNav.popOr(context, '/favorites'),
                      ),
                    ),
                    Positioned(
                      top: top + 8,
                      right: 12,
                      child: SoftCircleButton(
                        icon: _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        foreground: _isFavorite
                            ? const Color(0xFFC9A227)
                            : AppColors.navy,
                        onPressed: () {
                          if (!AppNav.requireAuth(
                            context,
                            next: '/favorites/${widget.id}',
                          )) {
                            return;
                          }
                          setState(() => _isFavorite = !_isFavorite);
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.cream,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppLayout.radiusSheet),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppLayout.radiusSheet),
                      ),
                      boxShadow: AppLayout.sheetShadow,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppFonts.playfair(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.category,
                          style: AppFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF175B68),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.place_outlined,
                              size: 18,
                              color: Color(0xFF5B6670),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.location,
                              style: AppFonts.dmSans(
                                fontSize: 14,
                                color: const Color(0xFF5B6670),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'À propos',
                          style: AppFonts.playfair(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description,
                          style: AppFonts.dmSans(
                            fontSize: 15,
                            height: 1.5,
                            color: const Color(0xFF3D4A52),
                          ),
                        ),
                      ],
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
