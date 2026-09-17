import '../theme/app_assets.dart';

class Parcours {
  const Parcours({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.places,
    required this.difficulty,
    required this.imageAsset,
    required this.description,
    required this.steps,
  });

  final String id;
  final String title;
  final String subtitle;
  final String duration;
  final int places;
  final String difficulty;
  final String imageAsset;
  final String description;
  final List<ParcoursStep> steps;
}

class ParcoursStep {
  const ParcoursStep({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  final String title;
  final String subtitle;
  final String imageAsset;
}

class FavoriteItem {
  const FavoriteItem({
    required this.title,
    required this.category,
    required this.location,
    required this.type,
    required this.imageAsset,
  });

  final String title;
  final String category;
  final String location;
  final String type;
  final String imageAsset;
}

class MockData {
  static const parcours = [
    Parcours(
      id: 'memoire-maritime',
      title: 'Circuit Mémoire maritime',
      subtitle:
          'Un voyage à travers l\'histoire maritime et les traditions des Kerkennah.',
      duration: '2h30',
      places: 5,
      difficulty: 'Facile',
      imageAsset: AppAssets.bgBoat,
      description:
          'Plongez dans l\'histoire maritime des Kerkennah : ports, pêche traditionnelle, savoir-faire et mémoire vivante des îles.',
      steps: [
        ParcoursStep(
          title: 'Charfiya',
          subtitle: 'Les anciens chantiers navals',
          imageAsset: AppAssets.bgBoat,
        ),
        ParcoursStep(
          title: 'Abbassiya',
          subtitle: 'Port et traditions de pêche',
          imageAsset: AppAssets.bgCoast,
        ),
        ParcoursStep(
          title: 'Île de Chergui',
          subtitle: 'Paysages et patrimoine vivant',
          imageAsset: AppAssets.bgVillage,
        ),
        ParcoursStep(
          title: 'Retour au large',
          subtitle: 'Horizon et transmission',
          imageAsset: AppAssets.bgFisherman,
        ),
      ],
    ),
    Parcours(
      id: 'ile-chergui',
      title: 'L\'île de Chergui',
      subtitle: 'Découverte des paysages, villages et lieux de mémoire.',
      duration: '1h45',
      places: 4,
      difficulty: 'Facile',
      imageAsset: AppAssets.bgVillage,
      description:
          'Une immersion douce dans les villages blancs, les palmiers et les points de vue sur la Méditerranée.',
      steps: [
        ParcoursStep(
          title: 'Remla',
          subtitle: 'Cœur vivant de Chergui',
          imageAsset: AppAssets.bgVillage,
        ),
        ParcoursStep(
          title: 'Plage de Sidi Frej',
          subtitle: 'Horizon et lumière',
          imageAsset: AppAssets.bgCoast,
        ),
      ],
    ),
  ];

  static const favorites = [
    FavoriteItem(
      title: 'Borj El Hsár',
      category: 'Site historique',
      location: 'Île Chergui',
      type: 'lieux',
      imageAsset: AppAssets.bgCoast,
    ),
    FavoriteItem(
      title: 'Mosquée Sidi Youssef',
      category: 'Lieu religieux',
      location: 'Île Gharbi',
      type: 'lieux',
      imageAsset: AppAssets.bgVillage,
    ),
    FavoriteItem(
      title: 'Plage de Sidi Fraj',
      category: 'Site naturel',
      location: 'Île Chergui',
      type: 'lieux',
      imageAsset: AppAssets.bgMap,
    ),
    FavoriteItem(
      title: 'Atelier de charfiya',
      category: 'Savoir-faire local',
      location: 'Kerkennah',
      type: 'lieux',
      imageAsset: AppAssets.bgBoat,
    ),
    FavoriteItem(
      title: 'Circuit Mémoire maritime',
      category: 'Parcours',
      location: 'Kerkennah',
      type: 'parcours',
      imageAsset: AppAssets.bgBoat,
    ),
    FavoriteItem(
      title: 'La voix des pêcheurs',
      category: 'Récit audio',
      location: 'Chergui',
      type: 'recits',
      imageAsset: AppAssets.bgFisherman,
    ),
  ];
}
