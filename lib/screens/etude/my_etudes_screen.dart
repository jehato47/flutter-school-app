import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school2/screens/etude/student_etude_screen.dart';

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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(StudentEtudeScreen.url);
            },
          )
        ],
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
              Color color;
              if (data[index]["state"] == "rejected")
                color = Colors.red;
              else if (data[index]["state"] == "done")
                color = Colors.green;
              else
                color = Colors.amber;

              return ListTile(
                onTap: () {},
                tileColor: color,
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
