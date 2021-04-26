import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/etude/register_button.dart';

class EtudesScreen extends StatefulWidget {
  static const url = "etudes";
  @override
  _EtudesScreenState createState() => _EtudesScreenState();
}

class _EtudesScreenState extends State<EtudesScreen> {
  bool isRequested = false;
  @override
  Widget build(BuildContext context) {
    // final auth = FirebaseAuth.instance;
    dynamic teacher = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(teacher["displayName"]),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("etude/${teacher.id}/pieces")
              // .where("uid", isEqualTo: teacher.id)
              // .where("date", isGreaterThanOrEqualTo: DateTime.now())
              // .where(
              //   "date",
              //   isLessThanOrEqualTo: DateTime.now().add(Duration(days: 10)),
              // )
              .get(),
          builder: (context, snapshot) {
            // print(teacher.id);
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            // print(snapshot.data.docs);
            List<QueryDocumentSnapshot> querySnapshot = snapshot.data.docs;

            return Column(
              children: [
                Text(
                  "Hangi tarihte etüt almak istiyorsunuz?",
                  style: TextStyle(fontSize: 30),
                ),
                Divider(thickness: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: querySnapshot.length,
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.all(0),
                      onTap: () {},
                      title: Text(
                        DateFormat("d MMMM EEEE yyyy").format(
                          querySnapshot[index]["date"].toDate(),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        DateFormat("HH - mm").format(
                              querySnapshot[index]["date"].toDate(),
                            ) +
                            (querySnapshot[index]["registered"].length == 0
                                ? "   henüz kayıtlı yok"
                                : "   ${querySnapshot[index]["registered"].length.toString()} kişi kayıtlı"),
                      ),
                      trailing: RegisterButton(
                        querySnapshot[index],
                        teacher,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
