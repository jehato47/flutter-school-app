import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyFriendsScreen extends StatelessWidget {
  static const url = "my-friends";

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context).userInfo;
    FirebaseAuth auth = FirebaseAuth.instance;
    final String myClass = userInfo["classFirst"] + "-" + userInfo["classLast"];
    bool isMe = userInfo == auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(myClass.toUpperCase()),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("user")
            .where("role", isEqualTo: "student")
            .where("classFirst", isEqualTo: userInfo["classFirst"])
            .where("classLast", isEqualTo: userInfo["classLast"])
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> students = snapshot.data.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {},
              tileColor: students[index].id == auth.currentUser!.uid
                  ? Colors.indigo[100]
                  : null,
              trailing: index == 0
                  ? const Icon(
                      Icons.star,
                      color: Colors.amber,
                    )
                  : null,
              leading: Text(
                "${index + 1}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              title: Text(students[index]["displayName"]),
            ),
          );
        },
      ),
    );
  }
}
