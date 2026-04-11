import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future<void> initialize(FlutterLocalNotificationsPlugin plugin) async {
    _notificationsPlugin = plugin;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap logic here
      },
    );

    // Request exact alarm permission for Android 14+
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
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
