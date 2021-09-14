import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import '../../screens/etude/teacher_etude_screen.dart';
import '../../widgets/home/pages_grid.dart';
import '../../widgets/home/side_drawer.dart';
import '../../widgets/home/homework_button.dart';
import '../../widgets/home/ring_bell.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../widgets/notification/notification_item.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  static const url = "home";
  final Function setIndex;
  HomeScreen(this.setIndex);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final Random random = Random();

class _HomeScreenState extends State<HomeScreen> {
  List<Color> colorCollection = [
    const Color(0xFF0F8644),
    const Color(0xFF8B1FA9),
    const Color(0xFFD20100),
    const Color(0xFFFC571D),
    const Color(0xFF36B37B),
    const Color(0xFF01A1EF),
    const Color(0xFF3D4FB5),
    const Color(0xFFE47C73),
    const Color(0xFF636363),
    const Color(0xFF0A8043),
  ];

  late Function setIndex;
  // dynamic body = PagesGrid();
  dynamic body = Placeholder();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget buildCard(String title, String subtitle, String fText,
      Function()? fFunc, String sText, Function()? sFunc) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.album,
                // color: Colors.teal,
              ),
              title: Text(title),
              subtitle: Text(subtitle),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: Text(fText),
                  onPressed: fFunc,
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: Text(sText),
                  onPressed: sFunc,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    CollectionReference ref =
        FirebaseFirestore.instance.collection("notification");

    return Column(
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(vertical: 10),
          height: 200,
          width: double.infinity,
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("notification")
                  .where("to", isEqualTo: "genel")
                  .orderBy("added", descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());

                List<QueryDocumentSnapshot> data = snapshot.data.docs;

                return Swiper(
                  loop: data.length > 1 ? true : false,
                  autoplay: true,
                  duration: 1500,

                  autoplayDelay: 4000,
                  onTap: (index) {
                    print(index);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //     begin: Alignment.bottomLeft,
                        //     end: Alignment.topRight,
                        //     colors: [
                        //       ...colorCollection.getRange(
                        //         index % 9,
                        //         index % 9 + 2,
                        //       )
                        //     ]),
                        color: colorCollection[index % 9],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        data[index]["text"],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  },
                  itemCount: data.length,

                  viewportFraction: 0.8,
                  scale: 0.9,
                  // itemCount: 3,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                );
              }),
        ),
        Divider(),
        SizedBox(
          height: 20,
          child: Text(
            "Genel Duyurular",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("notification")
                    .where("to", isEqualTo: "genel")
                    .orderBy("added", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  List<QueryDocumentSnapshot> data = snapshot.data.docs;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) =>
                        NotificationItem(ref, data[index]),
                  );
                }))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    setIndex = widget.setIndex;

    return Scaffold(
      // drawer: SideDrawer(),
      // appBar: AppBar(
      //   actions: [
      //     RingBell(),
      //     HomeworkButton(),
      //   ],
      //   title: Text(auth.currentUser.displayName),
      // ),
      body: buildBody(),
    );
  }
}
