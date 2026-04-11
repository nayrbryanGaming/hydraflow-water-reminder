import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize(FlutterLocalNotificationsPlugin plugin) async {
    _notificationsPlugin = plugin;

    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: darwinInitialize,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> requestPermissions() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  Future<void> scheduleRecurringHydrationReminders({
    required int intervalMinutes,
    required int startHour,
    required int endHour,
  }) async {
    await cancelAllReminders();

    final now = DateTime.now();
    var scheduleTime = DateTime(now.year, now.month, now.day, startHour);

    int idOffset = 0;
    while (scheduleTime.hour < endHour || (scheduleTime.hour == endHour && scheduleTime.minute == 0)) {
      if (scheduleTime.isBefore(now)) {
        scheduleTime = scheduleTime.add(Duration(minutes: intervalMinutes));
        continue;
      }

      await _notificationsPlugin.zonedSchedule(
        idOffset,
        'Time to Hydrate! 💧',
        'Drink some water to maintain your healthy habit.',
        tz.TZDateTime.from(scheduleTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            AppConstants.notificationChannelId,
            AppConstants.notificationChannelName,
            channelDescription: AppConstants.notificationChannelDesc,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        // Match only time so it repeats daily at this exact time
      );

      scheduleTime = scheduleTime.add(Duration(minutes: intervalMinutes));
      idOffset++;
    }
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}
