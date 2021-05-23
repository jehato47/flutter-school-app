import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'etude_chat_screen.dart';

class StudentEtudeForm extends StatefulWidget {
  static const url = "etude-form";
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
    final lecture = ModalRoute.of(context).settings.arguments;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ne zaman etüt almak istediğinizi ve bırakmak istediğiniz notu yazın",
                style: TextStyle(fontSize: 25),
              ),
              Divider(thickness: 1),
              SizedBox(height: 20),
              TextFormField(
                controller: controller,
                onSaved: (newValue) {
                  note = newValue;
                },
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                // initialValue: 'Input text',
                maxLength: 40,
                decoration: InputDecoration(
                  // icon: Icon(Icons.favorite),
                  labelText: 'Meramınızı anlatın',
                  labelStyle: TextStyle(
                    color: Color(0xFF6200EE),
                  ),
                  helperText:
                      'Kısa ve açıklayıcı olsun \nör: Salı günü saat 3 te meltem hoca',
                  // suffixIcon: Icon(
                  //   Icons.check_circle,
                  // ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6200EE)),
                  ),
                ),
              ),
              // TextFormField(
              //   onChanged: (value) {
              //     print(controller.text);
              //   },
              // onSaved: (newValue) {
              //   note = newValue;
              // },
              //   controller: controller,
              //   decoration: InputDecoration(hintText: "Meramınızı anlatın"),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DocumentReference eRequest = await FirebaseFirestore.instance
                      .collection("etudeRequest")
                      .add({
                    "displayName": auth.currentUser.displayName,
                    "lecture": lecture,
                    "uid": auth.currentUser.uid,
                    "date": DateTime.now(),
                    "note": controller.text,
                    "state": "waiting",
                    "ref": null,
                  });

                  await FirebaseFirestore.instance.collection("etudeChat").add({
                    "eRequestid": eRequest.id,
                    "note": controller.text,
                    "uid": auth.currentUser.uid,
                    "displayName": auth.currentUser.displayName,
                    "date": DateTime.now(),
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
