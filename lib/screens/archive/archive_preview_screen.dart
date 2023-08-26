import 'package:flutter/material.dart';
import '../../widgets/archive/archive_list_by_teachers.dart';

class ArchivePreviewScreen extends StatefulWidget {
  static const url = "archive-preview";
  @override
  _ArchivePreviewScreenState createState() => _ArchivePreviewScreenState();
}

class _ArchivePreviewScreenState extends State<ArchivePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kaynaklar"),
      ),
      body: ArchiveListByTeachers(),
    );
  }
}
