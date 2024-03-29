import 'package:flutter/material.dart';
import 'homework_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../notification/notification_empty.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class HomeworksList extends StatefulWidget {
  @override
  _HomeworksListState createState() => _HomeworksListState();
}

class _HomeworksListState extends State<HomeworksList> {
  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context).userInfo;
    // TODO : Production
    String classFirst = userInfo["classFirst"];
    String classLast = userInfo["classLast"];

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("homework")
          .where("classFirst", isEqualTo: "11")
          .where("classLast", isEqualTo: "a")
          .orderBy('startDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Birşeyler Ters Gitti..."));
        }
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        List docs = snapshot.data.docs;
        docs = List.from(docs.reversed);

        return Padding(
          padding: EdgeInsets.all(10),
          child: docs.length == 0
              ? NotificationEmpty()
              : ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return HomeworkItem(
                      docs[index],
                    );
                  },
                ),
        );
      },
    );
  }
}
