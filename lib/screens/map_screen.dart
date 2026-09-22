import 'package:flutter/material.dart';

import '../navigation/app_nav.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common_widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _minScale = 1.0;
  static const _maxScale = 4.0;
  static const _zoomStep = 0.4;

  late final TransformationController _transform;

  @override
  void initState() {
    super.initState();
    _transform = TransformationController();
  }

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  double get _currentScale {
    final m = _transform.value.getMaxScaleOnAxis();
    return m <= 0 ? 1.0 : m;
  }

  void _zoomBy(double factor, Size viewport) {
    final current = _currentScale;
    final next = (current * factor).clamp(_minScale, _maxScale);
    if ((next - current).abs() < 0.001) return;

    final focal = Offset(viewport.width / 2, viewport.height / 2);
    final sceneFocal = _transform.toScene(focal);
    _transform.value = Matrix4.identity()
      ..translateByDouble(focal.dx, focal.dy, 0, 1)
      ..scaleByDouble(next, next, 1, 1)
      ..translateByDouble(-sceneFocal.dx, -sceneFocal.dy, 0, 1);
  }

  void _resetZoom() {
    _transform.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const PalmLeafHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final viewport =
                    Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    InteractiveViewer(
                      transformationController: _transform,
                      minScale: _minScale,
                      maxScale: _maxScale,
                      panEnabled: true,
                      scaleEnabled: true,
                      boundaryMargin: const EdgeInsets.all(120),
                      child: SizedBox(
                        width: viewport.width,
                        height: viewport.height,
                        child: Image.asset(
                          AppAssets.bgMap,
                          fit: BoxFit.cover,
                          width: viewport.width,
                          height: viewport.height,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 16,
                      child: Column(
                        children: [
                          SoftCircleButton(
                            icon: Icons.near_me_outlined,
                            onPressed: _resetZoom,
                          ),
                          const SizedBox(height: 8),
                          SoftCircleButton(
                            icon: Icons.add,
                            onPressed: () =>
                                _zoomBy(1 + _zoomStep, viewport),
                          ),
                          const SizedBox(height: 8),
                          SoftCircleButton(
                            icon: Icons.remove,
                            onPressed: () =>
                                _zoomBy(1 / (1 + _zoomStep), viewport),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explorer la carte',
                              style: AppFonts.playfair(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Touchez un point pour ouvrir un parcours ou un récit.',
                              style: AppFonts.dmSans(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            PrimaryButton(
                              label: 'Voir un parcours',
                              onPressed: () =>
                                  AppNav.openParcoursDetail(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
