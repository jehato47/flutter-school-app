import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/homework/homework_item.dart';
import '../../providers/auth.dart';
import 'package:provider/provider.dart';

class HomeworkFilterScreen extends StatefulWidget {
  static const url = "hw-filter";
  @override
  _HomeworkFilterScreenState createState() => _HomeworkFilterScreenState();
}

class _HomeworkFilterScreenState extends State<HomeworkFilterScreen> {
  @override
  Widget build(BuildContext context) {
    final lecture = ModalRoute.of(context)!.settings.arguments;
    final userInfo = Provider.of<Auth>(context).userInfo;

    // TODO : PRODUCTION
    String classFirst = userInfo["classFirst"];
    String classLast = userInfo["classLast"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ödevler"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("homework")
                .where("classFirst", isEqualTo: "11")
                .where("classLast", isEqualTo: "a")
                .where("lecture", isEqualTo: lecture)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

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
