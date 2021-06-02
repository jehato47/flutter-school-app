import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_empty.dart';
import 'notification_item.dart';

class NotificationsList extends StatefulWidget {
  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notification")
            .orderBy('added', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Birşeyler Ters Gitti..."));
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );

          CollectionReference ref =
              FirebaseFirestore.instance.collection("notification");

          List _docs = snapshot.data.docs;

          return _docs.length == 0
              ? NotificationEmpty()
              : ListView.builder(
                  itemCount: _docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot notification = _docs[index];

                    return Column(
                      children: [
                        NotificationItem(
                          ref,
                          notification,
                          // user,
                        ),
                        Divider(
                          thickness: 1.2,
                        ),
                      ],
                    );
                  },
                );
        });
  }
}
