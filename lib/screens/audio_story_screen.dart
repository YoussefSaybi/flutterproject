import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class AudioStoryScreen extends StatefulWidget {
  const AudioStoryScreen({super.key});

  @override
  State<AudioStoryScreen> createState() => _AudioStoryScreenState();
}

class _AudioStoryScreenState extends State<AudioStoryScreen> {
  bool _playing = true;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              Image.asset(
                AppAssets.bgFisherman,
                height: 280,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: top + 8,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    SoftCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      background: AppColors.navy.withValues(alpha: 0.35),
                      foreground: Colors.white,
                      onPressed: () => AppNav.popOr(context, '/home'),
                    ),
                    const Expanded(child: EcoLogo(compact: true, height: 40)),
                    SoftCircleButton(
                      icon: Icons.bookmark_border,
                      background: AppColors.navy.withValues(alpha: 0.35),
                      foreground: Colors.white,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RÉCIT AUDIO',
                      style: AppFonts.dmSans(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'La voix des pêcheurs',
                      style: AppFonts.playfair(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Témoignage de Mahmoud, pêcheur à Chergui',
                      style: AppFonts.dmSans(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Transform.translate(
            offset: const Offset(0, -24),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                      activeTrackColor: AppColors.gold,
                      inactiveTrackColor: AppColors.border,
                      thumbColor: AppColors.gold,
                    ),
                    child: Slider(
                      value: 0.28,
                      onChanged: (_) {},
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('02:18', style: AppFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
                      Text('08:45', style: AppFonts.dmSans(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SoftCircleButton(icon: Icons.speed, onPressed: () {}, size: 40),
                      SoftCircleButton(icon: Icons.skip_previous, onPressed: () {}, size: 40),
                      SoftCircleButton(
                        icon: _playing ? Icons.pause : Icons.play_arrow,
                        background: AppColors.navy,
                        foreground: Colors.white,
                        onPressed: () => setState(() => _playing = !_playing),
                        size: 56,
                      ),
                      SoftCircleButton(icon: Icons.skip_next, onPressed: () {}, size: 40),
                      SoftCircleButton(icon: Icons.download_outlined, onPressed: () {}, size: 40),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mahmoud pêche depuis plus de 40 ans sur les côtes de Chergui. Il raconte la mer, les saisons et les gestes transmis.',
                  style: AppFonts.dmSans(color: AppColors.textSecondary, height: 1.45),
                ),
                const SizedBox(height: 16),
                Text(
                  'Extrait du récit',
                  style: AppFonts.dmSans(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '« La mer, ici, c\'est notre vie... »',
                  style: AppFonts.playfair(
                    color: AppColors.navy,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Voir la transcription complète ▼',
                  style: AppFonts.dmSans(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'À découvrir aussi',
                  style: AppFonts.playfair(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _Related(image: AppAssets.bgBoat, tag: 'RÉCIT AUDIO', title: 'Les saisons de la mer', meta: '07:12'),
                      _Related(image: AppAssets.bgVillage, tag: 'VIDÉO D\'ARCHIVE', title: 'Ports d\'autrefois', meta: '04:20'),
                      _Related(image: AppAssets.bgCoast, tag: 'GALERIE', title: 'Mémoire visuelle', meta: '12 photos'),
                    ],
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

class _Related extends StatelessWidget {
  const _Related({
    required this.image,
    required this.tag,
    required this.title,
    required this.meta,
  });

  final String image;
  final String tag;
  final String title;
  final String meta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.navy.withValues(alpha: 0.85)],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(tag, style: AppFonts.dmSans(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.w700)),
                  Text(title, style: AppFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(meta, style: AppFonts.dmSans(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
