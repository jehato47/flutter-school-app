import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFolderButton extends StatefulWidget {
  @override
  _AddFolderButtonState createState() => _AddFolderButtonState();
}

class _AddFolderButtonState extends State<AddFolderButton> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.create_new_folder_outlined),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Klasör oluştur"),
                SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: "Klasör ismini girin"),
                  minLines: 3,
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection("archive")
                          .add({
                        "date": DateTime.now(),
                        "displayName": auth.currentUser.displayName,
                        "folderName": controller.text.trim(),
                        "uid": auth.currentUser.uid,
                        "fileName": null,
                      });
                      controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text("Oluştur"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
