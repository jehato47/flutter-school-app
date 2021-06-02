import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  dynamic body = PagesGrid();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        actions: [
          RingBell(),
          HomeworkButton(),
        ],
        title: Text(auth.currentUser.displayName),
      ),
      body: body,
    );
  }
}
