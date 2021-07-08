import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/homework/homework_item.dart';

class HomeworkFilterScreen extends StatefulWidget {
  static const url = "hw-filter";
  @override
  _HomeworkFilterScreenState createState() => _HomeworkFilterScreenState();
}

class _HomeworkFilterScreenState extends State<HomeworkFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final lecture = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ödevler"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("homework")
                .where("lecture", isEqualTo: lecture)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());

              final data = snapshot.data.docs;

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => HomeworkItem(data[index]),
              );
            }),
      ),
    );
  }
}
