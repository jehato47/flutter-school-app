import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseTryScreen extends StatefulWidget {
  @override
  _FireBaseTryScreenState createState() => _FireBaseTryScreenState();
}

class _FireBaseTryScreenState extends State<FireBaseTryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("send"),
          onPressed: () async {
            FirebaseAuth auth = FirebaseAuth.instance;

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

            final response = await auth.signInWithEmailAndPassword(
              email: "jehatdeniz@hotmail.com",
              password: "123465789",
            );
            print(response);
            // response.user.sendEmailVerification();
          },
        ),
      ),
    );
  }
}
