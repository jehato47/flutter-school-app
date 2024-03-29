import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/etude/etude_chat/message_bubble.dart';
import '../../widgets/etude/etude_chat/inMessageInput.dart';

class InEtudeChatScreen extends StatefulWidget {
  static const url = "in-etude-chat";
  final dynamic id;

  const InEtudeChatScreen(this.id);
  @override
  _InEtudeChatScreenState createState() => _InEtudeChatScreenState();
}

class _InEtudeChatScreenState extends State<InEtudeChatScreen> {
  final ScrollController _scrollController = ScrollController();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    dynamic etudeId = widget.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Etüt Grup Sohbeti"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("inEtudeChat")
                  .where("id", isEqualTo: etudeId)
                  .orderBy("date")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent);
                  } else {
                    // setState(() => null);
                  }
                });
                List<QueryDocumentSnapshot> data = snapshot.data.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    bool isMe = data[index]["uid"] == auth.currentUser.uid;
                    return MessageBubble(
                      data[index]["message"],
                      data[index]["displayName"],
                      isMe,
                      DateTime.now(),
                    );
                  },
                  itemCount: data.length,
                );
              },
            ),
          ),
          InMessageInput(etudeId, _scrollController)
        ],
      ),
    );
  }
}
