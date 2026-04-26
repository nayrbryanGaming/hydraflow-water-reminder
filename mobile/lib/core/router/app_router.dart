import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/disclaimer_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/quiz_screen.dart';
import '../../features/reminders/screens/reminders_screen.dart';
import '../../features/achievements/screens/achievements_screen.dart';
import '../../features/settings/screens/profile_screen.dart';
import '../../features/settings/screens/legal_viewer_screen.dart';
import '../../widgets/premium_screen.dart';

import '../../features/settings/screens/settings_screen.dart';
import '../../features/hydration/screens/log_water_screen.dart';
import '../../features/onboarding/screens/permission_priming_screen.dart';
import '../../services/auth_service.dart';
import '../constants/legal_constants.dart';

import 'main_layout_screen.dart';

// ... other imports ...

const String routeOnboarding = '/onboarding';
const String routeDisclaimer = '/disclaimer';
const String routeQuiz = '/quiz';
const String routePermissionPriming = '/permission-priming';
const String routeRegister = '/register';
const String routeHome = '/home';
const String routeLogWater = '/home/log-water'; 
const String routeAnalytics = '/analytics';
const String routeReminders = '/reminders';
const String routeAchievements = '/achievements';
const String routeSettings = '/settings';
const String routeProfile = '/settings/profile';
const String routeLegal = '/legal';
const String routePremium = '/premium';


final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: routeOnboarding,
    redirect: (context, state) {
      final isLoggedIn = authService.currentUser != null;
      final isGoingToAuth = state.matchedLocation == routeRegister ||
          state.matchedLocation == routeOnboarding ||
          state.matchedLocation == routeDisclaimer ||
          state.matchedLocation == routeQuiz ||
          state.matchedLocation == routePermissionPriming;

      if (!isLoggedIn && !isGoingToAuth) {
        return routeOnboarding;
      }
      if (isLoggedIn && isGoingToAuth) {
        return routeHome;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: routeOnboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: routeDisclaimer,
        builder: (context, state) => const DisclaimerScreen(),
      ),
      GoRoute(
        path: routeQuiz,
        builder: (context, state) => const QuizScreen(),
      ),
      GoRoute(
        path: routePermissionPriming,
        builder: (context, state) => const PermissionPrimingScreen(),
      ),
      GoRoute(
        path: routeRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Top level persistent tab navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeHome,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'log-water',
                    builder: (context, state) => const LogWaterScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeAnalytics,
                builder: (context, state) => const AnalyticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeReminders,
                builder: (context, state) => const RemindersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: routeAchievements,
                builder: (context, state) => const AchievementsScreen(),
              ),
            ],
          ),
        ],
      ),

      // Outside tabs
      GoRoute(
        path: routeSettings,
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: routeLegal,
        builder: (context, state) {
          final type = state.extra as LegalType?;
          return LegalViewerScreen(
            type: type ?? LegalType.privacy,
          );
        },
      ),
      GoRoute(
        path: routePremium,
        builder: (context, state) => const PremiumScreen(),
      ),
    ],
  );
});


