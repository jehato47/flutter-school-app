import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../widgets/notification/add_notification_button.dart';
import '../../widgets/notification/notifications_list.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class NotificationScreen extends StatefulWidget {
  static const url = "/notification";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    if (!kIsWeb) {
      fbm.requestPermission();
      // Todo : Production
      fbm.subscribeToTopic("11-d");
      fbm.subscribeToTopic("genel");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    bool isTeacher = userInfo["role"] == "teacher";
    return Scaffold(
      floatingActionButton: !isTeacher
          ? null
          : FloatingActionButton(
              child: AddNotificationButton(),
              onPressed: () {},
            ),
      appBar: AppBar(
        actions: [
          // if (isTeacher) AddNotificationButton(),
        ],
        title: Text("Bildirimler"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NotificationsList(),
      ),
    );
  }
}
