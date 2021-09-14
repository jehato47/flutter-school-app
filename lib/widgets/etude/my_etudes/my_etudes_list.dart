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
          .where("uid", isEqualTo: auth.currentUser!.uid)
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var data = snapshot.data.docs;
        if (data.length == 0) {
          return const Center(
            child: Text(
              "Etüt istekleriniz burada görünür. Henüz etüt isteğiniz yok.",
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            bool isDone = data[index]["state"] != "waiting";
            Color color;
            if (data[index]["state"] == "rejected") {
              color = Colors.red;
            } else if (data[index]["state"] == "done") {
              color = Colors.green;
            } else {
              color = Colors.amber;
            }
            return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    EtudeChatScreen.url,
                    arguments: data[index],
                  );
                },
                title: Text(data[index]["note"]),
                subtitle: Text(data[index]["lecture"]),
                trailing: Icon(
                  isDone ? Icons.done : Icons.hourglass_bottom,
                  color: color,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
