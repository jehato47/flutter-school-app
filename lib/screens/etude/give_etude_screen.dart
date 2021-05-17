import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'show_etudes.dart';

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
        padding: EdgeInsets.all(size.width / 20),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("etudeTimes").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            QuerySnapshot querySnapshot = snapshot.data;
            dynamic liste =
                querySnapshot.docs.map((e) => e["lecture"]).toSet().toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: liste.length,
                    itemBuilder: (ctx, i) => ListTile(
                      contentPadding: EdgeInsets.all(0),
                      onTap: () {
                        dynamic lectureTeachers = querySnapshot.docs
                            .where((element) => element["lecture"] == liste[i])
                            .toList();
                        Navigator.of(context).pushNamed(
                          ShowEtudes.url,
                          arguments: lectureTeachers,
                        );
                      },
                      title: Text(
                        "${liste[i]} istekleri",
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
