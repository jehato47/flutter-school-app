import 'package:flutter/material.dart';
import '../../../screens/etude/etude_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEtudesList extends StatefulWidget {
  @override
  _MyEtudesListState createState() => _MyEtudesListState();
}

class _MyEtudesListState extends State<MyEtudesList> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
        if (data.length == 0)
          return Center(
            child: Text(
                "Etüt istekleriniz burada görünür. Henüz etüt isteğiniz yok."),
          );
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
              onTap: () {
                Navigator.of(context).pushNamed(
                  EtudeChatScreen.url,
                  arguments: data[index],
                );
              },
              tileColor: color,
              title: Text(data[index]["note"]),
              subtitle: Text(data[index]["lecture"]),
              trailing: Icon(isDone ? Icons.done : Icons.hourglass_bottom),
            );
          },
        );
      },
    );
  }
}
