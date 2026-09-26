import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../widgets/app_toast.dart';

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

  /// Start the featured circuit: open its fiche, or first étape if already there.
  static void startParcours(BuildContext context, {String? id}) {
    final target = id ?? parcoursId;
    final path = GoRouterState.of(context).uri.path;
    if (path == '/parcours/$target' || path.startsWith('/parcours/')) {
      context.push('/ar');
      return;
    }
    context.push('/parcours/$target');
  }

  static void openAr(BuildContext context) => context.push('/ar');
  static void openAudio(BuildContext context) => context.push('/audio');

  /// Opens login, optionally returning to [next] after success.
  static void openLogin(BuildContext context, {String? next}) {
    final q = (next != null && next.isNotEmpty)
        ? '?next=${Uri.encodeComponent(next)}'
        : '';
    context.push('/login$q');
  }

  static void openSignup(BuildContext context, {String? next}) {
    final q = (next != null && next.isNotEmpty)
        ? '?next=${Uri.encodeComponent(next)}'
        : '';
    context.push('/signup$q');
  }

  /// If logged in, returns true. Otherwise opens login and returns false.
  static bool requireAuth(BuildContext context, {String? next}) {
    if (AuthService.instance.isLoggedIn) return true;
    openLogin(context, next: next);
    return false;
  }

  /// Heart / Favoris — auth required.
  static void openFavorites(BuildContext context) {
    if (!requireAuth(context, next: '/favorites')) return;
    context.push('/favorites');
  }

  static void openFavoriteDetail(BuildContext context, String id) {
    final path = '/favorites/$id';
    if (!requireAuth(context, next: path)) return;
    context.push(path);
  }

  /// Bookmark / Enregistrement — auth required, then soft confirmation.
  static void openSave(BuildContext context, {String? label}) {
    final path = GoRouterState.of(context).uri.path;
    if (!requireAuth(context, next: path)) return;
    AppToast.success(
      context,
      label ?? 'Enregistré dans vos favoris.',
    );
  }

  /// After login / signup, go to [next] or home.
  static void finishAuth(BuildContext context, {String? next}) {
    final target = (next != null && next.isNotEmpty) ? next : '/home';
    context.go(target);
  }

  static void openEditProfile(BuildContext context) =>
      context.push('/edit-profile');

  static void openSettings(BuildContext context) =>
      context.push('/settings');

  static void openHelpSupport(BuildContext context) =>
      context.push('/help-support');

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
