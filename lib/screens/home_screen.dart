import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../services/auth_service.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';
import '../widgets/profile_photo.dart';

/// Accueil — CEO mock (image 2): cream canvas, centered gold logo,
/// pill search, map with floating controls, parcours card + dots.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _cardPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF4),
      body: Column(
        children: [
          // ── Teal header with palm-leaf shadow (same as Profil) ──
          const PalmLeafHeader(),

          Expanded(
            child: ListView(
              // No side padding here — map goes edge-to-edge.
              padding: const EdgeInsets.fromLTRB(0, 22, 0, 28),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _VisitorProfileAvatar(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bienvenue à Kerkennah',
                              style: AppFonts.playfair(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryTeal,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Explorez le patrimoine culturel des îles',
                              style: AppFonts.dmSans(
                                color: const Color(0xFF6B7A86),
                                height: 1.35,
                                fontSize: 14.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search overlaid on the map — small inset so they aren't flush.
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _HomeMap(onOpenMap: () => AppNav.goMap(context)),
                    Positioned(
                      top: 32,
                      left: 20,
                      right: 20,
                      child: AppSearchField(onTap: () => AppNav.goMap(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 176,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: parcours.length,
                      onPageChanged: (i) => setState(() => _cardPage = i),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _RecommendedCard(
                            parcours: parcours[i],
                            onDiscover: () => AppNav.goParcours(context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                PageDots(
                  count: parcours.length.clamp(1, 4),
                  index: _cardPage.clamp(0, parcours.length - 1),
                  onTap: (i) {
                    _pageController.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular visitor profile photo — taps through to Profil.
class _VisitorProfileAvatar extends StatelessWidget {
  const _VisitorProfileAvatar();

  static const double _size = 56;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AuthService.instance,
      builder: (context, _) {
        final user = AuthService.instance.currentUser;
        final name = user?.name.trim() ?? '';
        final initials = _initials(name);
        final photo = AuthService.instance.profilePhotoPath;

        return GestureDetector(
          onTap: () => AppNav.goProfile(context),
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFA58C78).withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.85),
                  width: 2,
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: ProfilePhoto(
                  path: photo,
                  size: _size,
                  placeholder: _FallbackAvatar(initials: initials),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts =
        name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    String firstChar(String s) {
      if (s.isEmpty) return '';
      return s.substring(0, 1).toUpperCase();
    }

    if (parts.length == 1) return firstChar(parts.first);
    return '${firstChar(parts.first)}${firstChar(parts.last)}';
  }
}

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    if (initials == '?' || initials.isEmpty) {
      return ColoredBox(
        color: const Color(0xFFE8F0F2),
        child: Icon(
          Icons.person_rounded,
          size: 30,
          color: AppColors.primaryTeal.withValues(alpha: 0.75),
        ),
      );
    }
    return ColoredBox(
      color: const Color(0xFF123F4A),
      child: Center(
        child: Text(
          initials,
          style: AppFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
          ),
        ),
      ),
    );
  }
}

class _HomeMap extends StatelessWidget {
  const _HomeMap({required this.onOpenMap});

  final VoidCallback onOpenMap;

  static const _pageCream = Color(0xFFFDFBF4);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpenMap,
      child: AspectRatio(
        // Lower ratio = taller map (style unchanged).
        aspectRatio: 1.18,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.bgMap,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF7EC8D4),
                alignment: Alignment.center,
                child: Text(
                  'Carte Kerkennah',
                  style: AppFonts.dmSans(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _SoftMapEdgePainter(cream: _pageCream),
                ),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 14,
              child: Container(
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapCtrlIcon(
                      icon: Icons.near_me_rounded,
                      onTap: onOpenMap,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                    _MapCtrlIcon(
                      icon: Icons.add_rounded,
                      onTap: onOpenMap,
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.black.withValues(alpha: 0.06),
                    ),
                    _MapCtrlIcon(
                      icon: Icons.remove_rounded,
                      onTap: onOpenMap,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Soft cream feather on map edges (same style as before).
class _SoftMapEdgePainter extends CustomPainter {
  const _SoftMapEdgePainter({required this.cream});

  final Color cream;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Same soft cream fade top and bottom.
    final topF = h * 0.28;
    final bottomF = h * 0.28;
    // Thin side feather only — keeps soft style without eating map width.
    final sideF = w * 0.02;

    void band(Rect rect, Alignment begin, Alignment end) {
      final paint = Paint()
        ..shader = ui.Gradient.linear(
          begin.withinRect(rect),
          end.withinRect(rect),
          [
            cream.withValues(alpha: 1.0),
            cream.withValues(alpha: 0.72),
            cream.withValues(alpha: 0.28),
            cream.withValues(alpha: 0.0),
          ],
          const [0.0, 0.28, 0.62, 1.0],
        );
      canvas.drawRect(rect, paint);
    }

    band(
      Rect.fromLTWH(0, 0, w, topF),
      Alignment.topCenter,
      Alignment.bottomCenter,
    );
    band(
      Rect.fromLTWH(0, h - bottomF, w, bottomF),
      Alignment.bottomCenter,
      Alignment.topCenter,
    );
    band(
      Rect.fromLTWH(0, 0, sideF, h),
      Alignment.centerLeft,
      Alignment.centerRight,
    );
    band(
      Rect.fromLTWH(w - sideF, 0, sideF, h),
      Alignment.centerRight,
      Alignment.centerLeft,
    );
  }

  @override
  bool shouldRepaint(covariant _SoftMapEdgePainter oldDelegate) {
    return oldDelegate.cream != cream;
  }
}

class _MapCtrlIcon extends StatelessWidget {
  const _MapCtrlIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 40,
        child: Icon(icon, size: 20, color: AppColors.primaryTeal),
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  const _RecommendedCard({
    required this.parcours,
    required this.onDiscover,
  });

  final Parcours parcours;
  final VoidCallback onDiscover;

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF1A365D);
    const meta = Color(0xFF1A365D);

    // Soft warm shadow — same language as the Accueil search bar.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA58C78).withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 98,
                  height: 124,
                  child: Image.asset(
                    parcours.imageAsset,
                    fit: BoxFit.cover,
                    width: 98,
                    height: 124,
                    alignment: const Alignment(0, -0.1),
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFFE8E4DC)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Parcours recommandé',
                      style: AppFonts.dmSans(
                        color: const Color(0xFFB8860B),
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      parcours.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.playfair(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: navy,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 13, color: meta),
                        const SizedBox(width: 2),
                        Text(
                          '${parcours.places} lieux',
                          style: AppFonts.dmSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: meta,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.schedule_rounded,
                            size: 13, color: meta),
                        const SizedBox(width: 2),
                        Text(
                          parcours.duration,
                          style: AppFonts.dmSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: meta,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _cardBlurb(parcours),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.dmSans(
                        fontSize: 11.5,
                        height: 1.3,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3D4F5C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _DiscoverPill(onTap: onDiscover),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _cardBlurb(Parcours parcours) {
    if (parcours.id == 'memoire-maritime') {
      return 'Un voyage à travers l\'histoire maritime '
          'et les traditions des Kerkennah.';
    }
    return parcours.subtitle;
  }
}

/// Compact CTA with the same sliding fleche as [PrimaryButton].
class _DiscoverPill extends StatefulWidget {
  const _DiscoverPill({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_DiscoverPill> createState() => _DiscoverPillState();
}

class _DiscoverPillState extends State<_DiscoverPill>
    with TickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 90),
    reverseDuration: const Duration(milliseconds: 320),
  );
  late final Animation<double> _scale = Tween<double>(begin: 1, end: 0.96)
      .animate(CurvedAnimation(
    parent: _press,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeOutBack,
  ));
  late final AnimationController _idle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);
  late final Animation<double> _idleSlide = Tween<double>(begin: 0, end: 3.5)
      .animate(CurvedAnimation(parent: _idle, curve: Curves.easeInOut));
  late final Animation<double> _pressSlide = Tween<double>(begin: 0, end: 2.5)
      .animate(CurvedAnimation(parent: _press, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _press.dispose();
    _idle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: Material(
        color: AppColors.primaryTeal,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (v) {
            if (v) {
              _press.forward();
            } else {
              _press.reverse();
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Découvrir le parcours',
                  maxLines: 1,
                  style: AppFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                AnimatedBuilder(
                  animation: Listenable.merge([_idle, _press]),
                  builder: (_, __) => Transform.translate(
                    offset: Offset(
                      _idleSlide.value + _pressSlide.value,
                      0,
                    ),
                    child: const SoftChevronIcon(
                      size: 15,
                      color: Colors.white,
                    ),
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
