import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Item extends StatefulWidget {
  final DocumentReference ref;
  Item(this.ref);
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.ref.get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        final data = snapshot.data;
        return ListTile(
          title: Text(data["username"]),
          // subtitle: Text(),
        );
      },
    );
  }
}
