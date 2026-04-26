
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'services/notification_service.dart';
import 'services/local_db_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Services in parallel or sequential with error handling


  try {
    // Initialize Hive (local storage)
    await Hive.initFlutter();
    await Hive.openBox('hydraflow_prefs');
    
    // Initialize Offline Local Database
    final localDb = LocalDbService();
    await localDb.init();
  } catch (e) {
    debugPrint('Hive Initialization Error: $e');
  }

  try {
    // Initialize timezone
    tz.initializeTimeZones();
    // Initialize notifications
    await NotificationService.instance.initialize(flutterLocalNotificationsPlugin);
  } catch (e) {
    debugPrint('Notification Initialization Error: $e');
  }

  runApp(const ProviderScope(child: HydraFlowApp()));
}

class HydraFlowApp extends ConsumerWidget {
  const HydraFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'HydraFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}


