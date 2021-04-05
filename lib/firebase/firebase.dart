import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './item.dart';
import 'dart:math';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  String classFirst;
  String classLast;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("send"),
            onPressed: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              CollectionReference syllabus =
                  FirebaseFirestore.instance.collection('syllabus');
              QuerySnapshot response = await syllabus.get();
              QueryDocumentSnapshot syl = response.docs[0];
              Map<Duration, String> map = {};
              List<Duration> liste = [];
              syl["monday"].forEach((key, value) {
                // print(key);
                DateTime date = DateTime.now();
                map[value.toDate().difference(date)] = key;
                liste.add(value.toDate().difference(date));
              });
              liste.sort();
              // print(map);
              classFirst = map[liste.first].split("-").first;
              classLast = map[liste.first].split("-").last;
              print(classFirst);
              print(classLast);
              // final x = lisÖte.reduce((value, element) => max(value, element));
              // map.print(map);

              // final response = await students.add({
              //   "username": "jehatad2",
              // });
              // print(response.docs[0]["arrivals"][0]);
              // final ref = await response.docs[0]["arrivals"][0].get();
              // print(ref["username"]);
              // final response2 = await ref.get();
              // print(response2["username"]);
              // response
              // try {
              //   UserCredential userCredential =
              //       await auth.createUserWithEmailAndPassword(
              //     email: "jehatdeniz@hotmail.com",
              //     password: "123465789",
              //   );

              //   userCredential.user.updateProfile();
              // } on FirebaseAuthException catch (e) {
              //   if (e.code == 'weak-password') {
              //     print('The password provided is too weak.');
              //   } else if (e.code == 'email-already-in-use') {
              //     print('The account already exists for that email.');
              //   }
              // } catch (e) {
              //   print(e);
              // }

              // try {
              //   UserCredential userCredential =
              //       await FirebaseAuth.instance.signInWithEmailAndPassword(
              //     email: "jehatdeniz@hotmail.com",
              //     password: "123465789",
              //   );
              //   print(userCredential);
              // } on FirebaseAuthException catch (e) {
              //   if (e.code == 'user-not-found') {
              //     print('No user found for that email.');
              //   } else if (e.code == 'wrong-password') {
              //     print('Wrong password provided for that user.');
              //   }
              // }
              // final response = await auth.signInWithEmailAndPassword(
              //   email: "jehatdeniz@hotmail.com",
              //   password: "123465789",
              // );
              // print(response);
              // response.user.sendEmailVerification();
            },
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("students")
                    .where("classFirst", isEqualTo: "11")
                    .where("classLast", isEqualTo: "a")
                    // .orderBy('classFirst', descending: true)
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
                  //     FirebaseFirestore.instance.collection("students");

                  List _docs = snapshot.data.docs;

                  // final user = await _docs[0]["ref"].get();
                  return ListView.builder(
                    itemCount: _docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Text(_docs[index]["username"]),
                      );
                    },
                  );
                }),
          ),
          SizedBox(
            width: double.infinity,
            child: Container(),
          )
        ],
      ),
    );
  }
}
