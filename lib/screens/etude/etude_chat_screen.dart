import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school2/widgets/etude/etude_chat/message_input.dart';
import 'package:intl/intl.dart';
import '../../widgets/etude/etude_chat/give_etude_bottomsheet.dart';
import '../../widgets/etude/etude_chat/messages.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';

class EtudeChatScreen extends StatefulWidget {
  static const url = "etude-chat";
  @override
  _EtudeChatScreenState createState() => _EtudeChatScreenState();
}

class _EtudeChatScreenState extends State<EtudeChatScreen> {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context, listen: false).userInfo;
    bool isTeacher = userInfo["role"] == "teacher";

    QueryDocumentSnapshot doc =
        ModalRoute.of(context).settings.arguments as dynamic;

    void _showBottomSheet() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return GiveEtudeBottomSheet(doc);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isTeacher)
            IconButton(
              icon: Icon(Icons.assignment),
              onPressed: () {
                _showBottomSheet();
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
            child: Messages(doc, _scrollController),
          ),
          MessageInput(doc, _scrollController),
        ],
      ),
    );
  }
}
