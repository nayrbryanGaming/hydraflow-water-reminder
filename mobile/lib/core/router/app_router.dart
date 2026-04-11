import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/screens/analytics_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/reminders/screens/reminders_screen.dart';
import '../../features/achievements/screens/achievements_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/hydration/screens/log_water_screen.dart';
import '../../services/auth_service.dart';

const String routeOnboarding = '/onboarding';
const String routeLogin = '/login';
const String routeRegister = '/register';
const String routeHome = '/home';
const String routeLogWater = '/log-water';
const String routeAnalytics = '/analytics';
const String routeReminders = '/reminders';
const String routeAchievements = '/achievements';
const String routeSettings = '/settings';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);

  return GoRouter(
    initialLocation: routeOnboarding,
    redirect: (context, state) {
      final isLoggedIn = authService.currentUser != null;
      final isGoingToAuth = state.matchedLocation == routeLogin ||
          state.matchedLocation == routeRegister ||
          state.matchedLocation == routeOnboarding;

      if (!isLoggedIn && !isGoingToAuth) {
        return routeLogin;
      }
      if (isLoggedIn && isGoingToAuth && state.matchedLocation != routeOnboarding) {
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
        path: routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: routeRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
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
      GoRoute(
        path: routeAnalytics,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: routeReminders,
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: routeAchievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: routeSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
