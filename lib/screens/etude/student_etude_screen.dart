import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import 'student_etude_form.dart';

class StudentEtudeScreen extends StatefulWidget {
  static const url = "student-etude";
  @override
  _StudentEtudeScreenState createState() => _StudentEtudeScreenState();
}

class _StudentEtudeScreenState extends State<StudentEtudeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dersler"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
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
                      onTap: () async {
                        // showDialog(
                        //   context: context,
                        //   builder: (context) => Dialog(
                        //     child: Container(
                        //       height: 200,
                        //       child: Column(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceAround,
                        //         children: [
                        //           TextFormField(
                        //             cursorColor: Theme.of(context)
                        //                 .textSelectionTheme
                        //                 .cursorColor,
                        //             initialValue: 'Input text',
                        //             maxLength: 20,
                        //             decoration: InputDecoration(
                        //               icon: Icon(Icons.favorite),
                        //               labelText: 'Label text',
                        //               labelStyle: TextStyle(
                        //                 color: Color(0xFF6200EE),
                        //               ),
                        //               helperText: 'Helper text',
                        //               suffixIcon: Icon(
                        //                 Icons.check_circle,
                        //               ),
                        //               enabledBorder: UnderlineInputBorder(
                        //                 borderSide: BorderSide(
                        //                     color: Color(0xFF6200EE)),
                        //               ),
                        //             ),
                        //           ),
                        //           ElevatedButton(
                        //               onPressed: () {}, child: Text("ww"))
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );
                        // return;
                        Navigator.of(context).pushNamed(
                          StudentEtudeForm.url,
                          arguments: liste[i],
                        );
                      },
                      title: Text(
                        liste[i],
                        style: TextStyle(fontSize: 20),
                      ),
                      leading: Icon(Icons.arrow_forward),
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
