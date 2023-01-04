import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:individual_project/model/ScheduleNHistory/SnHClass.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    final DarwinInitializationSettings  initializationSettingsIOS =
    DarwinInitializationSettings (
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
    ); // <------

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future addNotification(int startMili, String? email) async {
    var scheduledDate = DateTime.fromMillisecondsSinceEpoch(startMili).subtract(Duration(minutes: 10));
    var scheduledDateTz = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5));

    if (scheduledDate.isAfter(DateTime.now())){
      scheduledDateTz = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );
    }

    //DateTime tempDate = DateTime.fromMillisecondsSinceEpoch(startMili);
    int id = startMili~/10000;

    String body = "";

    if (email != null) {
      body = 'For ${email}. You have a class at in 10 minutes!';
    } else {
      body = 'You have a class at in 10 minutes!';
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'LetTutor Class Notification',
      body,
      scheduledDateTz,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'whatever',
            'whatever',
            icon: "@mipmap/ic_launcher",
            playSound: true,
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'notification',
            presentSound: true,
          ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future cancelNotification(int startMili) async {
    int id = startMili~/10000;
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}