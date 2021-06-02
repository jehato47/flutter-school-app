import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'in_archive_folder_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../widgets/archive/add_folder_button.dart';
import '../../widgets/archive/folders_list.dart';

class TeacherArchiveScreen extends StatefulWidget {
  static const url = "teacher-archive";
  @override
  _TeacherArchiveScreenState createState() => _TeacherArchiveScreenState();
}

class _TeacherArchiveScreenState extends State<TeacherArchiveScreen> {
  TextEditingController controller = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final uid = ModalRoute.of(context).settings.arguments;
    final isTeacher = Provider.of<Auth>(context).userInfo["role"] == "teacher";
    bool isMe = auth.currentUser.uid == uid;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (isTeacher && isMe) AddFolderButton(),
        ],
        title: Text("Arşiv"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FoldersList(uid),
      ),
    );
  }
}
