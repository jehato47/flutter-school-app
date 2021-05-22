import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/etude/etude_item.dart';

class StudentEtudeDetailScreen extends StatefulWidget {
  // TODO : Bu Sayfa Çöp Responsive
  static const url = "student-etude-detail";
  @override
  _StudentEtudeDetailScreenState createState() =>
      _StudentEtudeDetailScreenState();
}

class _StudentEtudeDetailScreenState extends State<StudentEtudeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final doc = ModalRoute.of(context).settings.arguments as dynamic;

    Widget buildStream(DocumentSnapshot docsnap) {
      return Expanded(
        child: StreamBuilder<Object>(
            stream: FirebaseFirestore.instance
                .collection("etude")
                .orderBy("date")
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
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: EtudeItem(
                    docs[index],
                    docsnap,
                  ),
                ),
              );
            }),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("etudeRequest")
                .doc(doc.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              DocumentSnapshot doc2 = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Öğrenci İsmi",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(),
                  Text(
                    doc2["displayName"],
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Bırakılan Not",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(),
                  Text(
                    doc2["note"],
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Ders",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(),
                  Text(
                    doc2["lecture"],
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Mevcut Etütler",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(),
                  buildStream(doc2),
                  SizedBox(height: 20),
                  Text(
                    "İstenme tarihi",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(),
                  Text(
                    DateFormat("dd-MM-yyyy HH:MM")
                        .format(doc2["date"].toDate()),
                    style: TextStyle(fontSize: 20),
                  ),
                  // SizedBox(height: 20),
                ],
              );
            }),
      ),
    );
  }
}
