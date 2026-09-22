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
  bool _showTranscript = false;
  double _progress = 0.28;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          PalmLeafHeader(
            child: Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: top + 8,
                  left: 8,
                  right: 8,
                  bottom: 14,
                ),
                child: Row(
                  children: [
                    SoftCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      background: AppColors.white.withValues(alpha: 0.15),
                      foreground: AppColors.white,
                      size: 40,
                      onPressed: () => AppNav.popOr(context, '/home'),
                    ),
                    const Spacer(),
                    SoftCircleButton(
                      icon: Icons.bookmark_border_rounded,
                      background: AppColors.white.withValues(alpha: 0.15),
                      foreground: AppColors.white,
                      size: 40,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(AppAssets.bgFisherman, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.black.withValues(alpha: 0.62),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RÉCIT AUDIO',
                              style: AppFonts.dmSans(
                                color: AppColors.gold,
                                fontSize: 11,
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'La voix des pêcheurs',
                              style: AppFonts.playfair(
                                color: AppColors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Témoignage de Mahmoud, pêcheur à Chergui',
                              style: AppFonts.dmSans(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppLayout.radiusCard),
                        boxShadow: AppLayout.softShadow,
                      ),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: AppColors.gold,
                              inactiveTrackColor:
                                  AppColors.navy.withValues(alpha: 0.18),
                              thumbColor: AppColors.gold,
                              overlayColor:
                                  AppColors.gold.withValues(alpha: 0.18),
                            ),
                            child: Slider(
                              value: _progress,
                              onChanged: (v) =>
                                  setState(() => _progress = v),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '02:18',
                                  style: AppFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '08:45',
                                  style: AppFonts.dmSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _SpeedChip(
                                label: '1x',
                                onTap: () {},
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  color: AppColors.navy,
                                  size: 30,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              SoftCircleButton(
                                icon: _playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                background: AppColors.navy,
                                foreground: AppColors.white,
                                size: 58,
                                onPressed: () =>
                                    setState(() => _playing = !_playing),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  color: AppColors.navy,
                                  size: 30,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.download_rounded,
                                  color: AppColors.navy,
                                  size: 26,
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mahmoud pêche depuis plus de 40 ans sur les côtes de Chergui. Il raconte la mer, les saisons et les gestes transmis de génération en génération à Kerkennah.',
                        style: AppFonts.dmSans(
                          color: AppColors.textSecondary,
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Extrait du récit',
                        style: AppFonts.dmSans(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '« La mer, ici, c\'est notre vie. Chaque matin, on lit le vent avant de lever les filets. La charfiya, ce n\'est pas seulement un métier — c\'est une mémoire. »',
                        style: AppFonts.playfair(
                          color: AppColors.navy,
                          fontStyle: FontStyle.italic,
                          fontSize: 17,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => setState(
                          () => _showTranscript = !_showTranscript,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Text(
                                _showTranscript
                                    ? 'Masquer la transcription'
                                    : 'Voir la transcription complète',
                                style: AppFonts.dmSans(
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                _showTranscript
                                    ? Icons.expand_less_rounded
                                    : Icons.expand_more_rounded,
                                color: AppColors.navy,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showTranscript) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(AppLayout.radiusMedium),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'Mon père m\'a appris à lire la mer avant même de savoir lire les livres. À Kerkennah, chaque baie a son rythme. Quand le vent tourne, on change de lieu. La charfiya demande de la patience, du respect pour le poisson, et du silence. C\'est ainsi que les anciens nous ont transmis leur savoir — sans grand discours, juste les gestes.',
                            style: AppFonts.dmSans(
                              color: AppColors.textSecondary,
                              height: 1.5,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 26),
                      Text(
                        'À découvrir aussi',
                        style: AppFonts.playfair(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 158,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [
                            _Related(
                              image: AppAssets.bgBoat,
                              tag: 'RÉCIT AUDIO',
                              title: 'Les saisons de la mer',
                              meta: '07:12',
                            ),
                            _Related(
                              image: AppAssets.bgVillage,
                              tag: 'VIDÉO D\'ARCHIVE',
                              title: 'Ports d\'autrefois',
                              meta: '04:20',
                            ),
                            _Related(
                              image: AppAssets.bgCoast,
                              tag: 'GALERIE',
                              title: 'Mémoire visuelle',
                              meta: '12 photos',
                            ),
                          ],
                        ),
                      ),
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

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: CustomPaint(
          painter: _DashedCirclePainter(
            color: AppColors.navy.withValues(alpha: 0.72),
          ),
          child: Center(
            child: Text(
              label,
              style: AppFonts.dmSans(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: AppColors.navy,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 1.5;
    const dashCount = 18;
    const gapRatio = 0.45;
    final sweep = (2 * 3.141592653589793) / dashCount;
    final dashSweep = sweep * (1 - gapRatio);

    for (var i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep - 1.5707963267948966,
        dashSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      oldDelegate.color != color;
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
      width: 168,
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppLayout.radiusMedium),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.navy.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    tag,
                    style: AppFonts.dmSans(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: AppFonts.dmSans(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    meta,
                    style: AppFonts.dmSans(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
