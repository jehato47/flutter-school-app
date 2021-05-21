import 'package:flutter/material.dart';
import 'student_etude_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class GiveEtudeScreen extends StatefulWidget {
  static const url = "/give-etude";
  @override
  _GiveEtudeScreenState createState() => _GiveEtudeScreenState();
}

class _GiveEtudeScreenState extends State<GiveEtudeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Etüt"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("etudeRequest")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            final docs = snapshot.data.docs;
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Color color;
                if (docs[index]["state"] == "rejected")
                  color = Colors.red;
                else if (docs[index]["state"] == "done")
                  color = Colors.green;
                else
                  color = Colors.amber;
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(border: Border.all(color: color, width: 2)),
                  child: ListTile(
                    // tileColor: color,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        StudentEtudeDetailScreen.url,
                        arguments: docs[index],
                      );
                    },
                    leading: Text(docs[index]["lecture"]),
                    title: Text(docs[index]["displayName"]),
                    subtitle: Text(docs[index]["note"]),
                    trailing: Text(
                      DateFormat("dd-MM-yyyy HH:MM").format(
                        docs[index]["date"].toDate(),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
