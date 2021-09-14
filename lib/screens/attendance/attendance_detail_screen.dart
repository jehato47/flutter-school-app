import 'package:flutter/material.dart';
import '../../widgets/attendance/attendance_detail_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceDetailScreen extends StatelessWidget {
  static const url = "/attendance-detail";
  @override
  Widget build(BuildContext context) {
    final attendance =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    bool isEmpty = attendance["info"]["notExists"].isEmpty;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gelmeyenler Listesi"),
      ),
      body: isEmpty
          ? const Center(
              child: Text("Gelmeyen öğrenci yokmuş"),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: attendance["info"]["notExists"].length,
                      itemBuilder: (ctx, i) => FutureBuilder(
                        future: attendance["info"]["notExists"][i].get(),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting) {
                            return const Image(
                              width: 100,
                              height: 100,
                              image: NetworkImage(
                                "https://media.giphy.com/media/3ov9k0Ziq50EoOuWRi/giphy.gif",
                              ),
                            );
                          }
                          // return ListTile(
                          //   title: Text(snapshot2.data["name"]),
                          // );
                          return AttendanceDetailItem(
                            snapshot2.data,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
