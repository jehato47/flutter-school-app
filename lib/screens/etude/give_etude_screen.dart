import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../providers/timetable.dart';
import '../../helpers/timetable/timetable_helpers.dart';
import '../../screens/attendance/attendace_check_screen.dart';
import 'package:provider/provider.dart';
import 'show_etudes.dart';

class GiveEtudeScreen extends StatefulWidget {
  static const url = "/give-etude";
  @override
  _GiveEtudeScreenState createState() => _GiveEtudeScreenState();
}

class _GiveEtudeScreenState extends State<GiveEtudeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etüt"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("etudeTimes").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            QuerySnapshot querySnapshot = snapshot.data;
            // print(querySnapshot.docs[0]["monday"]);
            dynamic liste =
                querySnapshot.docs.toSet().map((e) => e["lecture"]).toList();

            // liste.add("fizik");
            // liste.add("kimya");
            // liste.add("biyoloji");

            // print(liste);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hangi dersten etüt almak istiyorsun?",
                  style: TextStyle(fontSize: 30),
                ),
                Divider(thickness: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: liste.length,
                    itemBuilder: (ctx, i) => ListTile(
                      contentPadding: EdgeInsets.all(0),
                      onTap: () {
                        dynamic lectureTeachers = querySnapshot.docs
                            .where((element) => element["lecture"] == liste[i])
                            .toList();
                        Navigator.of(context).pushNamed(
                          ShowEtudes.url,
                          arguments: lectureTeachers,
                        );
                      },
                      title: Text(
                        liste[i],
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
