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
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.type,
    required this.imageAsset,
    required this.description,
  });

  final String id;
  final String title;
  final String category;
  final String location;
  final String type;
  final String imageAsset;
  final String description;
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
      imageAsset: AppAssets.bgParcoursMemoire,
      description:
          'Plongez dans l\'histoire maritime des Kerkennah : ports, pêche traditionnelle, savoir-faire et mémoire vivante des îles.',
      steps: [
        ParcoursStep(
          title: 'Charfiya',
          subtitle: 'Les anciens chantiers navals',
          imageAsset: AppAssets.bgParcoursMemoire,
        ),
        ParcoursStep(
          title: 'Port traditionnel',
          subtitle: 'Cœur battant des îliens',
          imageAsset: AppAssets.bgCoast,
        ),
        ParcoursStep(
          title: 'Abbassiya',
          subtitle: 'Histoire et spiritualité',
          imageAsset: AppAssets.bgAbbassiya,
        ),
        ParcoursStep(
          title: 'Retour au large',
          subtitle: 'Horizons et mémoire',
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
      id: 'borj-el-hsar',
      title: 'Borj El Hsar',
      category: 'Site historique',
      location: 'Île Chergui',
      type: 'lieux',
      imageAsset: AppAssets.bgCoast,
      description:
          'Fortin historique dominant la côte de Chergui, témoin de la mémoire défensive et maritime des Kerkennah.',
    ),
    FavoriteItem(
      id: 'mosquee-sidi-youssef',
      title: 'Mosquée Sidi Youssef',
      category: 'Lieu religieux',
      location: 'Île Gharbi',
      type: 'lieux',
      imageAsset: AppAssets.bgVillage,
      description:
          'Lieu de culte et de rassemblement sur l\'île Gharbi, au cœur de la vie spirituelle et villageoise.',
    ),
    FavoriteItem(
      id: 'plage-sidi-fraj',
      title: 'Plage de Sidi Fraj',
      category: 'Site naturel',
      location: 'Île Chergui',
      type: 'lieux',
      imageAsset: AppAssets.bgMap,
      description:
          'Longue plage de sable et d\'horizon méditerranéen, idéale pour une pause nature et lumière.',
    ),
    FavoriteItem(
      id: 'atelier-charfiya',
      title: 'Atelier de charfiya',
      category: 'Savoir-faire local',
      location: 'Kerkennah',
      type: 'lieux',
      imageAsset: AppAssets.bgBoat,
      description:
          'Découvrez le savoir-faire ancestral de la charfiya, filets de pêche traditionnels des îles Kerkennah.',
    ),
    FavoriteItem(
      id: 'circuit-memoire-maritime',
      title: 'Circuit Mémoire maritime',
      category: 'Parcours',
      location: 'Kerkennah',
      type: 'parcours',
      imageAsset: AppAssets.bgBoat,
      description:
          'Un voyage à travers l\'histoire maritime et les traditions vivantes des Kerkennah.',
    ),
    FavoriteItem(
      id: 'voix-pecheurs',
      title: 'La voix des pêcheurs',
      category: 'Récit audio',
      location: 'Chergui',
      type: 'recits',
      imageAsset: AppAssets.bgFisherman,
      description:
          'Écoutez les témoignages des pêcheurs de Chergui, gardiens d\'une mémoire orale unique.',
    ),
  ];
}
