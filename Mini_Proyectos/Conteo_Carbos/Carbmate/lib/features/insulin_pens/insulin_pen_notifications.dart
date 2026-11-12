import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import 'package:carbmate/features/foods/domain/food_repository.dart';

class InsulinPenNotifications {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  Future<void>? _initialization;

  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    timezone_data.initializeTimeZones();
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    timezone.setLocalLocation(timezone.getLocation(localTimezone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_carbmate'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<bool> requestPermission() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? true;
  }

  Future<bool> notificationsEnabled() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.areNotificationsEnabled() ?? true;
  }

  Future<void> openNotificationSettings() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.openAppNotificationSettings();
  }

  Future<void> schedulePen(
    InsulinPen pen, {
    bool notifyTodayIfLate = true,
  }) async {
    await initialize();
    await cancelPen(pen.id);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (var daysBeforeExpiry = 5; daysBeforeExpiry >= 0; daysBeforeExpiry--) {
      final alertDate = DateTime(
        pen.expiresOn.year,
        pen.expiresOn.month,
        pen.expiresOn.day - daysBeforeExpiry,
      );
      final alertDay = DateTime(alertDate.year, alertDate.month, alertDate.day);
      if (alertDay.isBefore(today)) continue;

      var scheduled = DateTime(alertDay.year, alertDay.month, alertDay.day, 9);
      if (scheduled.isBefore(now)) {
        if (!notifyTodayIfLate) continue;
        scheduled = now.add(const Duration(minutes: 2));
      }
      final message = switch (daysBeforeExpiry) {
        0 => '${pen.type.label} vence hoy.',
        1 => 'En 1 día vence ${pen.type.label}.',
        _ => 'En $daysBeforeExpiry días vence ${pen.type.label}.',
      };
      await _plugin.zonedSchedule(
        id: _notificationId(pen.id, daysBeforeExpiry),
        title: 'Vencimiento de lapicera',
        body: message,
        scheduledDate: timezone.TZDateTime.from(scheduled, timezone.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'insulin_pen_expiry',
            'Vencimiento de lapiceras',
            channelDescription:
                'Recordatorios sobre lapiceras de insulina abiertas.',
            importance: Importance.high,
            priority: Priority.high,
            icon: 'ic_stat_carbmate',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelPen(int penId) async {
    await initialize();
    for (var daysBeforeExpiry = 0; daysBeforeExpiry <= 5; daysBeforeExpiry++) {
      await _plugin.cancel(id: _notificationId(penId, daysBeforeExpiry));
    }
  }

  Future<void> scheduleAll(List<InsulinPen> pens) async {
    for (final pen in pens) {
      await schedulePen(pen, notifyTodayIfLate: false);
    }
  }

  int _notificationId(int penId, int daysBeforeExpiry) =>
      penId * 10 + daysBeforeExpiry;
}
