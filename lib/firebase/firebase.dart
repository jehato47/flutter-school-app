// import 'dart:html';
import '../providers/local_notification/local_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:school2/providers/attendance.dart';
import '../providers/auth.dart';
import './item.dart';
import 'dart:math';
import '../screens/attendance/attendance_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';
import 'package:url_launcher/url_launcher.dart';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  File file;
  String classFirst;
  String classLast;
  CollectionReference attendance;
  List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];
  Future<void> pickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      file = File(result.files.single.path);
    });
  }

  @override
  void initState() {
    super.initState();
    // var anroidInitialize = AndroidInitializationSettings("app_icon");
    // var iosInitializtioe = IOSInitializationSettings();
    // var initializeSettings = InitializationSettings(
    //     android: anroidInitialize, iOS: iosInitializtioe);
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // flutterLocalNotificationsPlugin.initialize(
    //   initializeSettings,
    //   onSelectNotification: onSelectNotification,
    // );
  }

  Future<void> showBigPictureNotification() async {
    var iosDetails = IOSNotificationDetails();
    var androidDetails = AndroidNotificationDetails(
      "Channel ID",
      "Random",
      "This is my channel",
      importance: Importance.max,
      icon: "app_icon",
      color: Colors.red,
      ledColor: Colors.green,
      ledOnMs: 1,
      ledOffMs: 2,
    );
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("flutter_devs"),
      largeIcon: DrawableResourceAndroidBitmap("flutter_devs"),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics,
        payload: "big image notifications");
  }

  Future _showNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("app_icon"),
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidDetails = AndroidNotificationDetails(
      "Channel ID", "Random", "This is my channel",
      importance: Importance.max,
      icon: "app_icon",
      color: Colors.red,
      ledColor: Colors.green,
      ledOnMs: 1,
      ledOffMs: 2,
      enableLights: true,
      // priority: Priority.max,
      subText: "subtextttt",
      // timeoutAfter: 300,
      // usesChronometer: true,
      showWhen: true,
      // fullScreenIntent: true,
      // onlyAlertOnce: true,
      autoCancel: true,
      priority: Priority.min,
      channelShowBadge: true,
      setAsGroupSummary: true,
      maxProgress: 5,
      tag: "tg23",
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
    );

    var iosDetails = IOSNotificationDetails();

    var generalDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin
        .show(0, "title", "body", generalDetails, payload: "veriqweqwe");
    // var time = DateTime.now().add(Duration(seconds: 5));

    // await flutterLocalNotificationsPlugin.schedule(
    //   1,
    //   "Task",
    //   "Scheduled Notification",
    //   time,
    //   generalDetails,
    // );
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          child: Text("tıklandı $payload"),
        ),
      ),
    );
  }

  Future<void> _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          ),
        ],
        title: Text("Çilem Akçay"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                CollectionReference ref =
                    FirebaseFirestore.instance.collection("notification");
                QuerySnapshot snapshot = await ref.get();
                print(snapshot);
              },
              child: Text(
                "btn",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
