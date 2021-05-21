import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentEtudeForm extends StatefulWidget {
  @override
  _StudentEtudeFormState createState() => _StudentEtudeFormState();
}

class _StudentEtudeFormState extends State<StudentEtudeForm> {
  TextEditingController controller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("Matematik Etüt"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ne zaman etüt almak istediğinizi ve bırakmak istediğiniz notu yazın",
                style: TextStyle(fontSize: 25),
              ),
              Divider(thickness: 1),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  print(controller.text);
                },
                onSaved: (newValue) {
                  note = newValue;
                },
                controller: controller,
                decoration: InputDecoration(hintText: "Meramınızı anlatın"),
              ),
              ElevatedButton(
                onPressed: () async {
                  print(controller.text);
                  // _formKey.currentState.save();
                  // QuerySnapshot snapshot = await FirebaseFirestore.instance
                  //     .collection("etudeRequest")
                  //     .where("date",
                  //         isLessThanOrEqualTo:
                  //             DateTime.now().add(Duration(days: 3)))
                  //     .where("lecture", isEqualTo: "fizik")
                  //     .where("uid", isEqualTo: auth.currentUser.uid)
                  //     .get();
                  // print(snapshot.docs);
                  // if (snapshot.docs.length > 0) {
                  //   ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       backgroundColor: Colors.red,
                  //       content: Text(
                  //           "Son üç gün içinde aynı derse tekrar istek gönderemezsiniz"),
                  //     ),
                  //   );
                  //   return;
                  // }

                  await FirebaseFirestore.instance
                      .collection("etudeRequest")
                      .add({
                    "displayName": auth.currentUser.displayName,
                    "lecture": "fizik",
                    "uid": auth.currentUser.uid,
                    "date": DateTime.now(),
                    "note": controller.text,
                    "state": "waiting",
                    "ref": null,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "Isteğiniz gönderildi",
                      ),
                    ),
                  );
                  _formKey.currentState.reset();
                },
                child: Text("Gönder"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
