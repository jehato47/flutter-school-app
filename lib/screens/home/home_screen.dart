import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:school2/screens/etude/teacher_etude_screen.dart';
import '../../widgets/home/pages_grid.dart';
import '../../widgets/home/side_drawer.dart';
import '../../widgets/home/homework_button.dart';
import '../../widgets/home/ring_bell.dart';

class HomeScreen extends StatefulWidget {
  static const url = "home";
  final Function setIndex;
  HomeScreen(this.setIndex);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Function setIndex;
  // dynamic body = PagesGrid();
  dynamic body = Placeholder();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget buildCard(String title, String subtitle, String fText, Function fFunc,
      String sText, Function sFunc) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
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
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          buildCard(
            "Alınmamış bir yoklamanız var",
            "Sınıf: 11-C  Saat: 11-40",
            "Al",
            () {},
            "Tamam",
            () {},
          ),
          buildCard(
            "Saat 12 de etüdünüz var",
            "Gelenler : Ahmet - Büşra - Mehmet",
            "Iptal Et",
            () {},
            "Incele",
            () {
              setIndex(4);
            },
          ),
          buildCard(
            "Bugün son gün olan 2 ödev var.",
            "11-C 11-D 11-F",
            "",
            () {},
            "Tamam",
            () {},
          ),
        ],
      ),
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
