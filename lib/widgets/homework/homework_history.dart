import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../screens/homework/homework_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/homework.dart';

class HomeworkHistory extends StatefulWidget {
  @override
  _HomeworkHistoryState createState() => _HomeworkHistoryState();
}

class _HomeworkHistoryState extends State<HomeworkHistory> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("homework")
            .where("uid", isEqualTo: auth.currentUser.uid)
            .orderBy("startDate")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          final hws = snapshot.data.docs;
          return ListView.builder(
            itemCount: hws.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.4,
              secondaryActions: [
                IconSlideAction(
                  caption: "Tekrarla",
                  icon: Icons.how_to_reg,
                  color: Colors.blue,
                  onTap: () {
                    // Provider.of<HomeWork>(context)
                    //     .addHomeWork(hws[index].data(), null);
                  },
                ),
              ],
              child: InkWell(
                onLongPress: () async {
                  await Provider.of<HomeWork>(context)
                      .deleteHomework(hws[index]);
                },
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    HomeWorkDetailScreen.url,
                    arguments: hws[index],
                  );
                },
                child: hwListTile(hws[index]),
              ),
            ),
          );
        });
  }

  ListTile hwListTile(hw) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          hw["teacherImage"],
        ),
      ),
      title: Text(hw["title"]),
      subtitle: Text(hw["homework"]),
      trailing: Text(
        hw["dueDate"].toDate().difference(DateTime.now()).inDays <= 0
            ? "Bitti"
            : hw["dueDate"]
                    .toDate()
                    .difference(DateTime.now())
                    .inDays
                    .toString() +
                " gün",
      ),
    );
  }
}
