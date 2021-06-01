import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/etude/message_bubble.dart';
import 'package:intl/intl.dart';
import '../../widgets/etude/etude_item.dart';

class EtudeChatScreen extends StatefulWidget {
  static const url = "etude-chat";
  @override
  _EtudeChatScreenState createState() => _EtudeChatScreenState();
}

class _EtudeChatScreenState extends State<EtudeChatScreen> {
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    FocusNode node = FocusNode();
    FirebaseAuth auth = FirebaseAuth.instance;
    QueryDocumentSnapshot doc =
        ModalRoute.of(context).settings.arguments as dynamic;

    Future<void> _send() async {
      if (_controller.text.trim().isEmpty) return;
      String text = _controller.text;
      _controller.clear();
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
      await FirebaseFirestore.instance.collection("etudeChat").add({
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

    void _showBottomSheet(dynamic docsnap) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          // Using Wrap makes the bottom sheet height the height of the content.
          // Otherwise, the height will be half the height of the screen.
          return Column(
            children: [
              ListTile(
                title: Text(
                  'Etütler',
                  style: theme.textTheme.subtitle1
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
                tileColor: theme.colorScheme.primary,
              ),
              Expanded(
                child: StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection("etude")
                      .orderBy("date")
                      .where("lecture", isEqualTo: "fizik")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    QuerySnapshot snap = snapshot.data;
                    List<QueryDocumentSnapshot> docs = snap.docs;

                    return ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: docs.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {},
                        child: EtudeItem(
                          docs[index],
                          docsnap,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.assignment),
            onPressed: () {
              _showBottomSheet(doc);
              return;
            },
          )
        ],
        title: Text(doc["lecture"]),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "İstek Tarihi " +
                  DateFormat("dd MMMM HH:mm").format(doc["date"].toDate()),
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: StreamBuilder(
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
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                }
                print(doc.id);
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                List<QueryDocumentSnapshot> docs = snapshot.data.docs;
                print(docs);
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
            ),
          ),
          // Spacer(),
          Container(
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
          )
        ],
      ),
    );
  }
}
