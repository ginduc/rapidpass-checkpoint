import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsHelper {
  /// Notify daily at 2am
  static Time get _notificationTime => Time(2, 0, 0);
  static AndroidNotificationDetails get _androidNotificationDetails =>
      AndroidNotificationDetails('rapidpass_checkpoint', 'RapidPass Checkpoint',
          'RapidPass notification',
          importance: Importance.Max,
          priority: Priority.High,
          ongoing: true,
          autoCancel: true);
  static IOSNotificationDetails get _iosNotificationDetails =>
      IOSNotificationDetails();

  static Future initialize() async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  }

  static Future setDailyNotifications() async {
    final notificationDetails = NotificationDetails(
        _androidNotificationDetails, _iosNotificationDetails);
    await FlutterLocalNotificationsPlugin().showDailyAtTime(
        0,
        'RapidPass Checkpoint',
        'Please sync your database to keep data updated',
        _notificationTime,
        notificationDetails);
  }
}
