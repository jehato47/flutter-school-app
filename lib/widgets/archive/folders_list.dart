import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../screens/archive/in_archive_folder_screen.dart';

class FoldersList extends StatefulWidget {
  final String uid;
  const FoldersList(this.uid);
  @override
  _FoldersListState createState() => _FoldersListState();
}

class _FoldersListState extends State<FoldersList> {
  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("archive")
            .where("uid", isEqualTo: uid)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          List<QueryDocumentSnapshot> files =
              snapshot.data.docs.toSet().toList();

          List folderNames = files.map((e) => e["folderName"]).toSet().toList();

          // print(folderNames);
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 150,
              mainAxisSpacing: 10,
              maxCrossAxisExtent: 200,
            ),
            itemCount: folderNames.length,
            itemBuilder: (context, index) => InkWell(
              onLongPress: () async {
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection("archive")
                    .where("uid", isEqualTo: uid)
                    .where("folderName", isEqualTo: folderNames[index])
                    .get();
                querySnapshot.docs.forEach((element) async {
                  await element.reference.delete();
                });

                final ref =
                    FirebaseStorage.instance.ref("$uid/${folderNames[index]}");

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
                  settings: RouteSettings(arguments: [
                    folderNames[index],
                    uid,
                  ]),
                  builder: (context) => InArchiveFolderScreen(),
                ));
              },
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.folder,
                    size: 120,
                    color: Colors.indigo[300],
                  ),
                  Text(folderNames[index]),
                ],
              ),
            ),
          );
        });
  }
}
