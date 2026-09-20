import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

/// Parcours tab — matches CEO mock (featured circuit + steps + CTA).
class ParcoursListScreen extends StatelessWidget {
  const ParcoursListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours.first;
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4EC),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero ──
          Stack(
            children: [
              Image.asset(
                parcours.imageAsset,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 300,
                  color: AppColors.navy,
                ),
              ),
              Positioned(
                top: top + 8,
                left: 14,
                child: SoftCircleButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () => AppNav.goHome(context),
                ),
              ),
              Positioned(
                top: top + 8,
                right: 14,
                child: SoftCircleButton(
                  icon: Icons.bookmark_border_rounded,
                  onPressed: () {},
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── White content sheet ──
          Transform.translate(
            offset: const Offset(0, -8),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parcours.title,
                    style: AppFonts.playfair(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF123F4A),
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    children: [
                      _Stat(
                        icon: Icons.schedule_rounded,
                        value: parcours.duration,
                        label: 'Durée',
                      ),
                      _VDivider(),
                      _Stat(
                        icon: Icons.place_outlined,
                        value: '${parcours.places}',
                        label: 'Étapes',
                      ),
                      _VDivider(),
                      _Stat(
                        icon: Icons.signal_cellular_alt_rounded,
                        value: parcours.difficulty,
                        label: 'Difficulté',
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    parcours.description,
                    style: AppFonts.dmSans(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xFF5B6670),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Étapes du parcours',
                    style: AppFonts.dmSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF123F4A),
                    ),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(parcours.steps.length, (i) {
                    final step = parcours.steps[i];
                    final locked = i == parcours.steps.length - 1;
                    return _StepRow(
                      index: i + 1,
                      step: step,
                      locked: locked,
                      showLine: i < parcours.steps.length - 1,
                      onTap: locked
                          ? null
                          : () => i.isEven
                              ? AppNav.openAr(context)
                              : AppNav.openAudio(context),
                    );
                  }),

                  const SizedBox(height: 8),
                  PrimaryButton(
                    label: 'Commencer le parcours',
                    onPressed: () => AppNav.startParcours(
                      context,
                      id: parcours.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: const Color(0xFFE2E6E8),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC9A227), size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppFonts.dmSans(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: const Color(0xFF123F4A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppFonts.dmSans(
              fontSize: 12,
              color: const Color(0xFF5B6670),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.step,
    required this.locked,
    required this.showLine,
    this.onTap,
  });

  final int index;
  final ParcoursStep step;
  final bool locked;
  final bool showLine;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: locked ? 0.4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: locked
                              ? const Color(0xFF9AA8AE)
                              : const Color(0xFFC9A227),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$index',
                          style: AppFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      if (showLine)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: const Color(0xFFE8E4DC),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    step.imageAsset,
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 54,
                      height: 54,
                      color: const Color(0xFFE8E4DC),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: AppFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF123F4A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          step.subtitle,
                          style: AppFonts.dmSans(
                            fontSize: 13,
                            color: const Color(0xFF5B6670),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Icon(
                    locked
                        ? Icons.lock_outline_rounded
                        : Icons.chevron_right_rounded,
                    color: const Color(0xFF9AA8AE),
                    size: 22,
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
