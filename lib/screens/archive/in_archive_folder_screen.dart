import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../widgets/archive/files_list.dart';
import '../../widgets/archive/add_files_button.dart';

class InArchiveFolderScreen extends StatefulWidget {
  @override
  _InArchiveFolderScreenState createState() => _InArchiveFolderScreenState();
}

class _InArchiveFolderScreenState extends State<InArchiveFolderScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final isTeacher = Provider.of<Auth>(context).userInfo["role"] == "teacher";
    final args = ModalRoute.of(context).settings.arguments as List;
    final folderName = args[0];
    final uid = args[1];
    bool isMe = auth.currentUser.uid == uid;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isTeacher && isMe) AddFilesButton(folderName),
        ],
        title: Text(folderName),
      ),
      body: FilesList(uid, folderName),
    );
  }
}
