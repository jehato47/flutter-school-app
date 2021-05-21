import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 5),
                    color: Colors.black12,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(docs[index]["teacherName"]),
                        Text(docs[index]["lecture"]),
                        Text(DateFormat("d MMMM EEEE")
                            .format(docs[index]["date"].toDate())),
                        Text(
                            "${docs[index]["registered"].length} kişi kayıtlı"),
                        ElevatedButton(
                          onPressed: docsnap["state"] == "done" &&
                                  docs[index].reference != docsnap["ref"]
                              ? null
                              : () async {
                                  List registered = docs[index]["registered"];
                                  if (!registered.contains(doc["uid"])) {
                                    registered.add(doc["uid"]);

                                    await FirebaseFirestore.instance
                                        .collection("etude")
                                        .doc(docs[index].id)
                                        .update({"registered": registered});

                                    await FirebaseFirestore.instance
                                        .collection("etudeRequest")
                                        .doc(doc.id)
                                        .update({
                                      "state": "done",
                                      "ref": docs[index].reference
                                    });
                                  } else {
                                    print(1111);
                                    registered.removeWhere(
                                        (element) => element == doc["uid"]);

                                    await FirebaseFirestore.instance
                                        .collection("etude")
                                        .doc(docs[index].id)
                                        .update({"registered": registered});

                                    await FirebaseFirestore.instance
                                        .collection("etudeRequest")
                                        .doc(doc.id)
                                        .update(
                                            {"state": "waiting", "ref": null});
                                  }
                                },
                          child: Text(docs[index].reference == docsnap["ref"]
                              ? "Geri Al"
                              : "kaydet"),
                        )
                      ],
                    ),
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
