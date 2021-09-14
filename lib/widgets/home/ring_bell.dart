import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/notifications/notification_screen.dart';

class RingBell extends StatefulWidget {
  @override
  _RingBellState createState() => _RingBellState();
}

class _RingBellState extends State<RingBell> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("notification").snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (auth.currentUser == null) return Container();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot == null) return Container();
          final docs = snapshot.data.docs;
          int length = 0;
          docs.forEach((element) {
            if (!element["isSeen"].contains(auth.currentUser!.uid)) length += 1;
          });

          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: "Bildirimler",
                icon: length != 0
                    ? const Icon(Icons.notifications_active)
                    : const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).pushNamed(NotificationScreen.url);
                },
              ),
              Positioned(
                right: 8,
                top: 10,
                child: Container(
                  alignment: Alignment.center,
                  width: length >= 10 ? 20 : 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: Text(
                    length.toString(),
                    style: const TextStyle(
                      // color: Colors.red,
                      // fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }
}
