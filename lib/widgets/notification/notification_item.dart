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
  NotificationP notificationP;
  void download() async {
    if (notification["fileName"] == null) return;
    final url = await notificationP.getDownloadUrl(notification);
    if (!kIsWeb) {
      _launchURL(url);
    } else {
      _launchURL(url);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("indiriliyor"),
      backgroundColor: Colors.green,
    ));
  }

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

    notificationP = Provider.of<NotificationP>(context);

    return Tooltip(
      message: notification["fileName"] != null
          ? notification["fileName"]
          : "dosya eklenmedi",
      child: ListTile(
        onLongPress: () {
          addToSeen(ref, notification);
          download();
        },

        // onLongPress: () {
        //   // TODO : Productionda bunu ekle
        //   // if (user["position"] == "admin")
        //   notificationP.deleteNotification(
        //     ref,
        //     notification,
        //   );
        // },
        selected: !notification["isSeen"].contains(auth.currentUser.uid),
        trailing: notification["isSeen"].contains(auth.currentUser.uid)
            ? Text(
                notification["to"],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: notification["to"] == "genel" ? Colors.teal : null,
                ),
              )
            : Icon(Icons.notification_important),
        title: Text(
          //* ?TODO : Eğer text
          //* ?TODO : çok uzun olursa truncate etmeye bak
          notification["text"],
          style: TextStyle(fontFamily: "source-sans"),
        ),
        subtitle: Text(
          DateFormat("d MMMM yyyy HH-mm").format(
            notification["added"].toDate(),
          ),
          style: TextStyle(fontFamily: "source-sans"),
        ),
        onTap: () {
          // Görenlere ekliyor
          // download();
          addToSeen(ref, notification);
        },
        leading: notification["fileName"] == null
            ? null
            : Icon(
                Icons.file_present,
                // size: 35,
              ),
      ),
    );
  }
}
