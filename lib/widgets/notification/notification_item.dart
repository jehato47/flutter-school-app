import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';
import '../../helpers/download/download_helper_provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class NotificationItem extends StatefulWidget {
  final ref;
  final notification;
  // final user;
  NotificationItem(
    this.ref,
    this.notification,
    // this.user,
  );
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  void _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference ref;
  DocumentSnapshot notification;
  dynamic user;

  void addToSeen(CollectionReference ref, DocumentSnapshot notification) {
    List peopleWhoSee = notification["isSeen"];

    if (!peopleWhoSee.contains(auth.currentUser.uid)) {
      peopleWhoSee.add(auth.currentUser.uid);
    }
    ref.doc(notification.id).update({"isSeen": peopleWhoSee});
  }

  @override
  Widget build(BuildContext context) {
    ref = widget.ref;
    notification = widget.notification;
    // user = widget.user;

    NotificationP notificationP = Provider.of<NotificationP>(context);

    return ListTile(
      onLongPress: () {
        // TODO : Productionda bunu ekle
        // if (user["position"] == "admin")
        notificationP.deleteNotification(
          ref,
          notification,
        );
      },
      selected: !notification["isSeen"].contains(auth.currentUser.uid),
      leading: notification["isSeen"].contains(auth.currentUser.uid)
          ? Icon(Icons.assignment)
          : Icon(Icons.notification_important),
      title: Text(
        //* ?TODO : Eğer text
        //* ?TODO : çok uzun olursa truncate etmeye bak
        notification["text"],
        style: TextStyle(fontFamily: "source-sans"),
      ),
      subtitle: Text(
        DateFormat("d MMMM yyyy").format(
          notification["added"].toDate(),
        ),
        style: TextStyle(fontFamily: "source-sans"),
      ),
      onTap: () {
        // Görenlere ekliyor
        addToSeen(ref, notification);
      },
      trailing: notification["fileName"] == null
          ? null
          : IconButton(
              tooltip: notification["fileName"],
              icon: Icon(
                Icons.file_present,
              ),
              onPressed: () async {
                final url = await notificationP.getDownloadUrl(notification);
                if (!kIsWeb) {
                  await Provider.of<Download>(context).downloadFile(
                    url,
                    notification["fileName"],
                  );
                } else {
                  _launchURL(url);
                }
              },
            ),
    );
  }
}
