import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatefulWidget {
  final dynamic doc;
  final ScrollController scrollController;
  Messages(this.doc, this.scrollController);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = widget.scrollController;
    dynamic doc = widget.doc;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("etudeChat")
          .where(
            "eRequestid",
            isEqualTo: doc.id,
          )
          .orderBy("date")
          .snapshots(),
      builder: (context, snapshot) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }

        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        List<QueryDocumentSnapshot> docs = snapshot.data.docs;

        return ListView.builder(
          // reverse: true,
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return MessageBubble(
              docs[index].data()["note"],
              docs[index].data()["displayName"],
              // docs[index].data()["userImage"],
              docs[index].data()["uid"] == auth.currentUser.uid,
              docs[index]["date"].toDate(),
              key: ValueKey(docs[index].id),
            );
          },
        );
      },
    );
  }
}
