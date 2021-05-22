import 'package:flutter/material.dart';
import 'student_etude_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'etude_chat_screen.dart';
import 'package:intl/intl.dart';
import '../../helpers/help.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
            if (docs.length == 0)
              return Center(
                child: Text(
                    "Etüt istekleri burada gözükür. Henüz istek bulunmamakta."),
              );
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
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    // tileColor: color,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        EtudeChatScreen.url,
                        arguments: docs[index],
                      );
                    },
                    leading: Text(
                      kIsWeb
                          ? docs[index]["lecture"]
                          : truncateString(docs[index]["lecture"], 5),
                    ),
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
