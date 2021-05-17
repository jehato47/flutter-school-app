import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyEtudesScreen extends StatefulWidget {
  static const url = "my-etudes";
  @override
  _MyEtudesScreenState createState() => _MyEtudesScreenState();
}

class _MyEtudesScreenState extends State<MyEtudesScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etütlerim"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("etudeRequest")
            .where("uid", isEqualTo: auth.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          var data = snapshot.data.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              bool isDone = data[index]["state"] != "waiting";
              return ListTile(
                onTap: () {},
                tileColor: isDone ? Colors.green : Colors.amber,
                title: Text(data[index]["note"]),
                subtitle: Text(data[index]["lecture"]),
                trailing: Icon(isDone ? Icons.done : Icons.hourglass_bottom),
              );
            },
          );
        },
      ),
    );
  }
}
