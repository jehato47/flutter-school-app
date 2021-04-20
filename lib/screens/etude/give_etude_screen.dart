import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiveEtudeScreen extends StatefulWidget {
  static const url = "/give-etude";
  @override
  _GiveEtudeScreenState createState() => _GiveEtudeScreenState();
}

class _GiveEtudeScreenState extends State<GiveEtudeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etüt"),
      ),
      body: Center(
        child: Text("Etüt ver"),
      ),
    );
  }
}
