import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageInput extends StatefulWidget {
  final dynamic doc;
  final ScrollController scrollController;
  MessageInput(this.doc, this.scrollController);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _controller = TextEditingController();
  FocusNode node = FocusNode();

  Future<void> _send() async {
    ScrollController _scrollController = widget.scrollController;
    dynamic doc = widget.doc;

    if (_controller.text.trim().isEmpty) return;
    String text = _controller.text;
    _controller.clear();
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
    await FirebaseFirestore.instance.collection("etudeChat").add({
      "created": false,
      "uid": auth.currentUser.uid,
      "eRequestid": doc.id,
      "note": text,
      "displayName": auth.currentUser.displayName,
      "date": DateTime.now(),
    });
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      // TODO: Burada row'u niye kullandığına bak
      child: Row(
        children: [
          // TODO : Var olan alanı tamamen kapladığı için textfield'ı expanded
          // içine koyduk
          Expanded(
            child: TextField(
              focusNode: node,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              onSubmitted: (value) async {
                await _send();
                node.requestFocus();
              },
              textInputAction: TextInputAction.send,
              controller: _controller,
              onChanged: (value) {
                // setState(() {
                //   _enteredMessage = value;
                // });
              },
              decoration: InputDecoration(
                labelText: "Cevap Yazın",
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: _send,
          )
        ],
      ),
    );
  }
}
