import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared navigation helpers for EcoAR screens.
class AppNav {
  static const parcoursId = 'memoire-maritime';
  static String get parcoursDetail => '/parcours/$parcoursId';

  static void goHome(BuildContext context) => context.go('/home');
  static void goMap(BuildContext context) => context.go('/map');
  static void goParcours(BuildContext context) => context.go('/parcours');
  static void goScanner(BuildContext context) => context.go('/scanner');
  static void goProfile(BuildContext context) => context.go('/profile');

  static void openParcoursDetail(BuildContext context) =>
      context.push(parcoursDetail);

  static void openAr(BuildContext context) => context.push('/ar');
  static void openAudio(BuildContext context) => context.push('/audio');
  static void openFavorites(BuildContext context) => context.push('/favorites');
  static void openEditProfile(BuildContext context) =>
      context.push('/edit-profile');

  static void openCredits(BuildContext context) =>
      context.push('/credits?from=menu');

  static void popOr(BuildContext context, String fallback) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(fallback);
    }
  }
}
