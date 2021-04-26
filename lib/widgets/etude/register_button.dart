import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegisterButton extends StatefulWidget {
  final querySnapshot;
  final teacher;
  RegisterButton(this.querySnapshot, this.teacher);
  @override
  _RegisterButtonState createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  @override
  Widget build(BuildContext context) {
    dynamic querySnaphsot = widget.querySnapshot;
    dynamic teacher = widget.teacher;
    FirebaseAuth auth = FirebaseAuth.instance;
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("etude/${teacher.id}/pieces")
            .doc(querySnaphsot.id)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Text("1 sn");
          // print(snapshot.data);
          DocumentSnapshot documentSnapshot = snapshot.data;
          // print(documentSnapshot.data());
          querySnaphsot = documentSnapshot;
          return TextButton(
            onPressed: () async {
              List liste = querySnaphsot["registered"];

              if (!liste.contains(auth.currentUser.uid))
                liste.add(auth.currentUser.uid);
              else
                liste.remove(auth.currentUser.uid);

              await FirebaseFirestore.instance
                  .collection("etude/${teacher.id}/pieces")
                  .doc("${querySnaphsot.id}")
                  .update({"registered": liste});

              setState(() {});
            },
            child: Text(
              querySnaphsot["registered"].contains(auth.currentUser.uid)
                  ? "kayıtlısın"
                  : "kayıt ol",
              style: TextStyle(
                color:
                    querySnaphsot["registered"].contains(auth.currentUser.uid)
                        ? Colors.grey
                        : Colors.blue,
              ),
            ),
          );
        });
  }
}
