import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import '../../widgets/home/pages_grid.dart';
import '../../widgets/home/side_drawer.dart';
import '../../widgets/home/homework_button.dart';
import '../../widgets/home/ring_bell.dart';

class HomeScreen extends StatefulWidget {
  static const url = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // dynamic body = PagesGrid();
  dynamic body = Placeholder();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.red),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "etüt",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.indigo),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "ödev",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    width: double.infinity,
                    height: 200,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
