import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification.dart';
import '../../helpers/download/download_helper_provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItem extends StatefulWidget {
  final ref;
  final notification;
  final user;
  NotificationItem(this.ref, this.notification, this.user);
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  CollectionReference ref;
  DocumentSnapshot notification;
  dynamic user;

  void addToSeen(CollectionReference ref, DocumentSnapshot notification) {
    List peopleWhoSee = notification["isSeen"];

    if (!peopleWhoSee.contains(user["user"])) {
      peopleWhoSee.add(user["user"]);
    }
    ref.doc(notification.id).update({"isSeen": peopleWhoSee});
  }

  @override
  Widget build(BuildContext context) {
    ref = widget.ref;
    notification = widget.notification;
    user = widget.user;

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
      selected: !notification["isSeen"].contains(user["user"]),
      leading: notification["isSeen"].contains(user["user"])
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

                await Provider.of<Download>(context).downloadFile(
                  url,
                  notification["fileName"],
                );
              },
            ),
    );
  }
}
