import 'package:flutter/material.dart';
import '../../screens/archive/archive_preview_screen.dart';

class ArchiveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(ArchivePreviewScreen.url);
      },
      icon: Icon(Icons.file_present),
    );
  }
}
