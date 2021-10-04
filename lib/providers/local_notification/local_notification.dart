import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PushNotification extends ChangeNotifier {
  Future<void> showNotification(
    Function onSelectNotification,
    String title,
    String body,
    String payload,
  ) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    var anroidInitialize = AndroidInitializationSettings("ic_launcher");
    var iosInitializtioe = IOSInitializationSettings();
    var initializeSettings = InitializationSettings(
        android: anroidInitialize, iOS: iosInitializtioe);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidDetails = AndroidNotificationDetails(
      "Channel ID",
      "Random",
      "This is my channel",
      importance: Importance.max,
      icon: "ic_launcher",
      ledColor: Colors.green,
      ledOnMs: 1,
      ledOffMs: 2,
      enableLights: true,
      showWhen: true,
      autoCancel: true,
      channelShowBadge: true,
      setAsGroupSummary: true,
      tag: "tg23",
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      enableVibration: false,
    );

    var iosDetails = IOSNotificationDetails();

    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      generalDetails,
      payload: payload,
    );
  }

  Future<void> showScheduledNotification(
    Function onSelectNotification,
    String title,
    String body,
    String payload,
    DateTime time,
  ) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    var anroidInitialize = AndroidInitializationSettings("ic_launcher");
    var iosInitializtioe = IOSInitializationSettings();
    var initializeSettings = InitializationSettings(
        android: anroidInitialize, iOS: iosInitializtioe);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidDetails = AndroidNotificationDetails(
      "Channel ID",
      "Random",
      "This is my channel",
      importance: Importance.max,
      icon: "ic_launcher",
      ledColor: Colors.green,
      ledOnMs: 1,
      ledOffMs: 2,
      enableLights: true,
      showWhen: true,
      autoCancel: true,
      channelShowBadge: true,
      setAsGroupSummary: true,
      tag: "tg23",
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    var iosDetails = IOSNotificationDetails();

    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.schedule(
      1,
      title,
      body,
      time,
      generalDetails,
      payload: payload,
    );
  }

  Future<void> showWeeklyAppointment(
    Function onSelectNotification,
    String title,
    String body,
    String payload,
    // DateTime time,
  ) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

    var anroidInitialize = AndroidInitializationSettings("ic_launcher");
    var iosInitializtioe = IOSInitializationSettings();
    var initializeSettings = InitializationSettings(
        android: anroidInitialize, iOS: iosInitializtioe);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializeSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidDetails = AndroidNotificationDetails(
      "Channel ID",
      "Random",
      "This is my channel",
      importance: Importance.max,
      icon: "ic_launcher",
      ledColor: Colors.green,
      ledOnMs: 1,
      ledOffMs: 2,
      enableLights: true,
      showWhen: true,
      autoCancel: true,
      channelShowBadge: true,
      setAsGroupSummary: true,
      tag: "tg23",
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    var iosDetails = IOSNotificationDetails();

    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      'On Monday Morning',
      'Your Prayer at Monday',
      Day.tuesday,
      Time(20, 51, 0),
      generalDetails,
    );
  }
}
