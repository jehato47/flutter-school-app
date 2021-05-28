import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'in_archive_folder_screen.dart';

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
    List items = ["limit", "türev", "integral"];
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
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
                          decoration:
                              InputDecoration(labelText: "Klasör ismini girin"),
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
                                "displayName": auth.currentUser.displayName,
                                "folderName": controller.text,
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
            )
          ],
          title: Text("Arşiv"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("archive")
                  .where("uid", isEqualTo: auth.currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                List<QueryDocumentSnapshot> files =
                    snapshot.data.docs.toSet().toList();

                List folderNames =
                    files.map((e) => e["folderName"]).toSet().toList();

                print(folderNames);
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 150,
                    mainAxisSpacing: 10,
                    maxCrossAxisExtent: 200,
                  ),
                  itemCount: folderNames.length,
                  itemBuilder: (context, index) => InkWell(
                    onLongPress: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection("archive")
                          .where("uid", isEqualTo: auth.currentUser.uid)
                          .where("folderName", isEqualTo: folderNames[index])
                          .get();
                      querySnapshot.docs.forEach((element) async {
                        await element.reference.delete();
                      });
                      print("${auth.currentUser.uid}/${folderNames[index]}");
                      final ref = FirebaseStorage.instance
                          .ref("${auth.currentUser.uid}/${folderNames[index]}");

                      await ref.listAll().then((result) async {
                        for (var item in result.items) {
                          await item.delete();
                        }
                      }).catchError((error) {
                        // Handle any errors
                      });
                    },
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        settings: RouteSettings(arguments: folderNames[index]),
                        builder: (context) => InArchiveFolderScreen(),
                      ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Center(child: Text(folderNames[index])),
                      color: Colors.indigo[100],
                    ),
                  ),
                );
              }),
        ));
  }
}
