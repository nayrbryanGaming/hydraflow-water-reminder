import 'dart:io';
import 'dart:math' as math;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize(FlutterLocalNotificationsPlugin plugin) async {
    if (_isInitialized) return;
    
    _notificationsPlugin = plugin;
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');
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

    // Initialization complete. 
    // Note: Permissions are requested via requestPermissions() 
    // to ensure user education before system prompts.
    
    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      // Standard notification permission
      await _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
      
      // Exact alarm permission (Optional but recommended for consistency)
      // Check status first to avoid redundant prompts
      final status = await Permission.scheduleExactAlarm.status;
      if (status.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } else if (Platform.isIOS) {
       await _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> scheduleSmartReminders({
    required int consumedMl,
    required int goalMl,
    required int startHour,
    required int endHour,
  }) async {
    await cancelAllReminders();

    if (consumedMl >= goalMl) {
      return;
    }

    final now = DateTime.now();
    final percent = (consumedMl / goalMl).clamp(0.0, 1.0);
    
    // For policy compliance, we check if we actually have exact alarm permission.
    // Starting in Android 14, exact_alarm is a restricted permission.
    bool canScheduleExact = true;
    if (Platform.isAndroid) {
      canScheduleExact = await Permission.scheduleExactAlarm.isGranted;
    }

    final dayLength = endHour - startHour;
    final interval = dayLength / 4;

    for (int i = 0; i < 4; i++) {
        final jitter = (math.Random().nextInt(30) - 15);
        final scheduleHour = startHour + (interval * (i + 1)).toInt();
        if (scheduleHour >= endHour) break;

        var scheduleTime = DateTime(now.year, now.month, now.day, scheduleHour, jitter);
        if (scheduleTime.isBefore(now)) {
            scheduleTime = scheduleTime.add(const Duration(days: 1));
        }

        final message = _getSmartMessage(i, percent);

        await _notificationsPlugin.zonedSchedule(
            i,
            'HydraFlow 💧',
            message,
            tz.TZDateTime.from(scheduleTime, tz.local),
            const NotificationDetails(
                android: AndroidNotificationDetails(
                    AppConstants.notificationChannelId,
                    AppConstants.notificationChannelName,
                    importance: Importance.max,
                    priority: Priority.high,
                    enableVibration: true,
                    showWhen: true,
                ),
                iOS: DarwinNotificationDetails(
                  presentAlert: true,
                  presentBadge: true,
                  presentSound: true,
                ),
            ),
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time,
            // Fallback to inexact if permission is not granted to avoid security exceptions or policy rejections
            androidScheduleMode: canScheduleExact 
                ? AndroidScheduleMode.exactAllowWhileIdle 
                : AndroidScheduleMode.inexactAllowWhileIdle,
        );
    }
  }

  String _getSmartMessage(int slot, double percent) {
    if (percent >= 1.0) return 'You have reached your goal! Keep it up! 🎉';
    
    final messages = [
        ['Good morning! Start your day with a fresh glass of water. ☀️', 'How is your morning hydration going? 🥛'],
        ['Time for a midday refill. Stay focused! ⚡', 'Are you keeping up with your goal? Drink now. 💧'],
        ['Keep the momentum going! You are doing great. 🚀', 'Almost evening! Don\'t forget to drink. 🌆'],
        ['Wrap up your day with a final hydrating drop. 🌙', 'Closing in on your daily goal! Finish strong. 🔥'],
    ];

    final subSlot = percent < 0.5 ? 1 : 0;
    return messages[slot][subSlot];
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }
}


