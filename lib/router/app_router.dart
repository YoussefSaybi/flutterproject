import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/ar_light_screen.dart';
import '../screens/audio_story_screen.dart';
import '../screens/chatbot_screen.dart';
import '../screens/credits_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/home_screen.dart';
import '../screens/eco_ar_login_screen.dart';
import '../screens/map_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/parcours_detail_screen.dart';
import '../screens/parcours_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/scanner_screen.dart';
import '../screens/eco_ar_signup_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/main_shell.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/credits',
        pageBuilder: (context, state) {
          final fromMenu = state.uri.queryParameters['from'] == 'menu';
          return _fadePage(
            key: state.pageKey,
            child: CreditsScreen(fromMenu: fromMenu),
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (_, state) => _fadePage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (_, state) => _fadePage(
          key: state.pageKey,
          child: const EcoArLoginScreen(),
        ),
      ),
      GoRoute(path: '/signup', builder: (_, __) => const EcoArSignUpScreen()),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return _fadePage(
            key: state.pageKey,
            child: MainShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/map', builder: (_, __) => const MapScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/parcours',
                builder: (_, __) => const ParcoursListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/scanner', builder: (_, __) => const ScannerScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/parcours/:id',
        builder: (context, state) => ParcoursDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: '/audio', builder: (_, __) => const AudioStoryScreen()),
      GoRoute(path: '/ar', builder: (_, __) => const ArLightScreen()),
      GoRoute(path: '/edit-profile', builder: (_, __) => const EditProfileScreen()),
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
      GoRoute(path: '/chatbot', builder: (_, __) => const ChatbotScreen()),
    ],
  );
}
