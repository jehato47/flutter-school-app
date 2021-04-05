import 'package:flutter/material.dart';
import 'homework_preview_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../notification/notification_empty.dart';

class HomeworkPreviewList extends StatefulWidget {
  @override
  _HomeworkPreviewListState createState() => _HomeworkPreviewListState();
}

class _HomeworkPreviewListState extends State<HomeworkPreviewList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // future: Provider.of<HomeWork>(context, listen: false).getHwByClass(token),
      stream: FirebaseFirestore.instance
          .collection("homework")
          .where("classFirst", isEqualTo: "11")
          .where("classLast", isEqualTo: "a")
          .orderBy('startDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Birşeyler Ters Gitti..."));
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );

        // CollectionReference ref =
        //     FirebaseFirestore.instance.collection("notification");

        List docs = snapshot.data.docs;
        docs = List.from(docs.reversed);

        return Padding(
          padding: EdgeInsets.all(10),
          child: docs.length == 0
              ? NotificationEmpty()
              : ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return HomeworkPreviewItem(
                      docs[index],
                    );
                  },
                ),
        );
      },
    );
  }
}
