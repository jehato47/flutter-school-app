import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../screens/etude/in_etude_chat_screen.dart';

class TeacherEtudeScreen extends StatefulWidget {
  static const url = "teacher-etude";
  @override
  _TeacherEtudeScreenState createState() => _TeacherEtudeScreenState();
}

class _TeacherEtudeScreenState extends State<TeacherEtudeScreen> {
  ScrollController _scrollController = new ScrollController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etütleriniz")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("etude")
            .where("uid", isEqualTo: auth.currentUser!.uid)
            .where("onSaved", isEqualTo: true)
            .orderBy("date")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot> data = snapshot.data.docs;

          return ListView.builder(
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var subject = data[index]["subject"] == null
                    ? "Henüz konu belirlenmedi"
                    : data[index]["subject"];

                return Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.indigo, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => InEtudeChatScreen(data[index].id),
                      ));
                    },
                    title: Text("Konu: $subject"),
                    subtitle: Text(
                      DateFormat("d MMMM EEEE ").format(
                        data[index]["date"].toDate(),
                      ),
                    ),
                    trailing: Text(
                      "Kayıtlı: ${data[index]["registered"].length} kişi",
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
