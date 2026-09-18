import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../navigation/app_nav.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class ParcoursDetailScreen extends StatelessWidget {
  const ParcoursDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    final parcours = MockData.parcours.firstWhere(
      (p) => p.id == id,
      orElse: () => MockData.parcours.first,
    );
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
                      parcours.imageAsset,
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: top + 8,
                      left: 12,
                      child: SoftCircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onPressed: () => AppNav.popOr(context, '/home'),
                      ),
                    ),
                    Positioned(
                      top: top + 8,
                      right: 12,
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcours.title,
                          style: AppFonts.playfair(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _Stat(icon: Icons.schedule, value: parcours.duration, label: 'Durée'),
                            _Stat(icon: Icons.place_outlined, value: '${parcours.places}', label: 'Étapes'),
                            _Stat(icon: Icons.signal_cellular_alt, value: parcours.difficulty, label: 'Difficulté'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          parcours.description,
                          style: AppFonts.dmSans(color: AppColors.textSecondary, height: 1.45),
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Étapes du parcours',
                          style: AppFonts.playfair(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(parcours.steps.length, (i) {
                          final step = parcours.steps[i];
                          final locked = i == parcours.steps.length - 1;
                          return Opacity(
                            opacity: locked ? 0.45 : 1,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: locked
                                    ? null
                                    : () => i.isEven
                                        ? AppNav.openAr(context)
                                        : AppNav.openAudio(context),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: locked
                                            ? AppColors.textSecondary
                                            : AppColors.gold,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${i + 1}',
                                        style: AppFonts.dmSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        step.imageAsset,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            step.title,
                                            style: AppFonts.dmSans(
                                              color: AppColors.navy,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            step.subtitle,
                                            style: AppFonts.dmSans(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      locked
                                          ? Icons.lock_outline_rounded
                                          : Icons.chevron_right_rounded,
                                      color: AppColors.navy,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: PrimaryButton(
                label: 'Commencer le parcours',
                onPressed: () => AppNav.openAr(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navy),
          ),
          Text(label, style: AppFonts.dmSans(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
