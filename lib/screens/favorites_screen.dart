import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Mes favoris — matches CEO Favorites mock exactly.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _filter = 'tous';
  late final List<FavoriteItem> _items = List.of(MockData.favorites);

  void _removeFavorite(FavoriteItem item) {
    setState(() => _items.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    final items = _items.where((f) {
      if (_filter == 'tous') return true;
      return f.type == _filter;
    }).toList();
    final top = MediaQuery.paddingOf(context).top;
    final size = MediaQuery.sizeOf(context);
    // Tall teal header matching the mock screenshot.
    final headerH = top + size.height * 0.20;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      body: Column(
        children: [
          // ── Header: palm-leaf shadow (left + right) + logo ──
          SizedBox(
            height: headerH,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const PalmLeafBackdrop(),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, top + 4, 16, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      AppAssets.logoGold,
                      height: 92,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                      errorBuilder: (_, __, ___) => Text(
                        'EcoAR',
                        style: AppFonts.playfair(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 16),
              children: [
                Text(
                  'Mes favoris',
                  style: AppFonts.playfair(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF123F4A),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vos lieux, parcours et histoires préférés à retrouver à tout moment.',
                  style: AppFonts.dmSans(
                    fontSize: 14,
                    color: const Color(0xFF5B6670),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),

                // Filter pills
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
                        icon: const Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: Color(0xFF123F4A),
                        ),
                        selected: _filter == 'lieux',
                        onTap: () => setState(() => _filter = 'lieux'),
                      ),
                      _FilterPill(
                        label: 'Parcours',
                        icon: const ParcoursPathIcon(
                          size: 15,
                          color: Color(0xFF123F4A),
                        ),
                        selected: _filter == 'parcours',
                        onTap: () => setState(() => _filter = 'parcours'),
                      ),
                      _FilterPill(
                        label: 'Récits',
                        icon: const Icon(
                          Icons.menu_book_outlined,
                          size: 15,
                          color: Color(0xFF123F4A),
                        ),
                        selected: _filter == 'recits',
                        onTap: () => setState(() => _filter = 'recits'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Text(
                      'Aucun favori dans cette catégorie.',
                      textAlign: TextAlign.center,
                      style: AppFonts.dmSans(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ),

                ...items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FavoriteCard(
                      item: item,
                      onTap: () => AppNav.openFavoriteDetail(context, item.id),
                      onUnfavorite: () => _removeFavorite(item),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom nav (Profil active, like mock) ──
          const _FavoritesBottomNav(),
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
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: selected ? const Color(0xFF123F4A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: selected
                    ? const Color(0xFF123F4A)
                    : const Color(0xFF123F4A),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null && !selected) ...[
                  icon!,
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: AppFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : const Color(0xFF123F4A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.item,
    required this.onTap,
    required this.onUnfavorite,
  });

  final FavoriteItem item;
  final VoidCallback onTap;
  final VoidCallback onUnfavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.imageAsset,
                    width: 78,
                    height: 68,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 78,
                      height: 68,
                      color: const Color(0xFFE8E4DC),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF123F4A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.category,
                        style: AppFonts.dmSans(
                          fontSize: 13,
                          color: const Color(0xFF175B68),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.place_outlined,
                            size: 13,
                            color: Color(0xFF5B6670),
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.dmSans(
                                fontSize: 12,
                                color: const Color(0xFF5B6670),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                IconButton(
                  onPressed: onUnfavorite,
                  tooltip: 'Retirer des favoris',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  icon: const Icon(
                    Icons.favorite_rounded,
                    size: 22,
                    color: Color(0xFFC9A227),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Color(0xFF9AA8AE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesBottomNav extends StatelessWidget {
  const _FavoritesBottomNav();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              _NavItem(
                asset: AppAssets.navAccueil,
                assetActive: AppAssets.navAccueilActive,
                onTap: () => context.go('/home'),
              ),
              _NavItem(
                asset: AppAssets.navCarte,
                assetActive: AppAssets.navCarteActive,
                onTap: () => context.go('/map'),
              ),
              _NavItem(
                asset: AppAssets.navParcours,
                assetActive: AppAssets.navParcoursActive,
                onTap: () => context.go('/parcours'),
              ),
              _NavItem(
                asset: AppAssets.navScanner,
                assetActive: AppAssets.navScannerActive,
                onTap: () => context.go('/scanner'),
              ),
              _NavItem(
                asset: AppAssets.navProfil,
                assetActive: AppAssets.navProfilActive,
                selected: true,
                onTap: () => context.go('/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.asset,
    required this.assetActive,
    required this.onTap,
    this.selected = false,
  });

  final String asset;
  final String assetActive;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Image.asset(
              selected ? assetActive : asset,
              height: 34,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
