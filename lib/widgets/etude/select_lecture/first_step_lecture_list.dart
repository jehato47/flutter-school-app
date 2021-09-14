import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../screens/etude/etude_form_screen.dart';

class FirstStepLectureList extends StatefulWidget {
  @override
  _FirstStepLectureListState createState() => _FirstStepLectureListState();
}

class _FirstStepLectureListState extends State<FirstStepLectureList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // TODO : Burayı etude collection a göre düzenle
      stream: FirebaseFirestore.instance.collection("etudeTimes").snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                  contentPadding: const EdgeInsets.all(0),
                  onTap: () async {
                    Navigator.of(context).pushNamed(
                      EtudeFormScreen.url,
                      arguments: liste[i],
                    );
                  },
                  title: Text(
                    liste[i],
                    style: const TextStyle(fontSize: 20),
                  ),
                  leading: const Icon(Icons.arrow_forward),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
