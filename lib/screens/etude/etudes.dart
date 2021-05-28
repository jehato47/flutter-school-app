import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/etude/etude_item.dart';

class EtudesScreen extends StatefulWidget {
  static const url = "etudes-screen";
  @override
  _EtudesScreenState createState() => _EtudesScreenState();
}

class _EtudesScreenState extends State<EtudesScreen> {
  Widget buildStream(DocumentSnapshot docsnap) {
    return StreamBuilder<Object>(
      stream: FirebaseFirestore.instance
          .collection("etude")
          .orderBy("date")
          .where("lecture", isEqualTo: "fizik")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        QuerySnapshot snap = snapshot.data;
        List<QueryDocumentSnapshot> docs = snap.docs;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: docs.length,
          itemBuilder: (context, index) => EtudeItem(
            docs[index],
            docsnap,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context).settings.arguments as dynamic;

    return Scaffold(
      appBar: AppBar(),
      body: buildStream(doc),
    );
  }
}
