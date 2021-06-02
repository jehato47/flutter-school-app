import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../screens/etude/etude_chat_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../helpers/help.dart';

class EtudeRequestList extends StatefulWidget {
  @override
  _EtudeRequestListState createState() => _EtudeRequestListState();
}

class _EtudeRequestListState extends State<EtudeRequestList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("etudeRequest")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        final requests = snapshot.data.docs;
        if (requests.length == 0)
          return Center(
            child: Text(
              "Etüt istekleri burada gözükür. Henüz istek bulunmamakta.",
            ),
          );

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            Color color;
            if (requests[index]["state"] == "rejected")
              color = Colors.red;
            else if (requests[index]["state"] == "done")
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
                    arguments: requests[index],
                  );
                },
                leading: Text(
                  kIsWeb
                      ? requests[index]["lecture"]
                      : truncateString(requests[index]["lecture"], 5),
                ),
                title: Text(requests[index]["displayName"]),
                subtitle: Text(requests[index]["note"]),
                trailing: Text(
                  DateFormat("dd-MM-yyyy HH:MM").format(
                    requests[index]["date"].toDate(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
