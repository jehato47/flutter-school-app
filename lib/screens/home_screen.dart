import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school2/firebase/firebase.dart';
import 'package:school2/screens/homework/give_homework_screen.dart';
// import '../providers/auth.dart';
import '../widgets/home/pages_grid.dart';
import '../widgets/home/bottom_navbar.dart';

import '../screens/home/main_home_screen.dart';
import '../screens/notifications/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  static const url = "home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic body = PagesGrid();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget buildRingBell(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("notification").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final docs = snapshot.data.docs;
          int length = 0;
          docs.forEach((element) {
            if (!element["isSeen"].contains(auth.currentUser.uid)) length += 1;
          });

          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                tooltip: "Bildirimler",
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.of(context).pushNamed(NotificationScreen.url);
                },
              ),
              Positioned(
                right: 8,
                top: 10,
                child: Container(
                  alignment: Alignment.center,
                  width: length >= 10 ? 20 : 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: Text(
                    length.toString(),
                    style: TextStyle(
                      // color: Colors.red,
                      // fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget buildHomeworkButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.amber,
        ),
        margin: EdgeInsets.all(8),
        child: IconButton(
          tooltip: "Ödev Ver",
          color: Colors.indigo,
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(GiveHomeworkScreen.url);
          },
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        // semanticLabel: "Drawer",
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
                backgroundBlendMode: BlendMode.colorDodge,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.wallpapersden.com/image/wxl-desert-night-illustration_63345.jpg",
                  ),
                ),
              ),
              currentAccountPicture: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  fit: BoxFit.cover,
                  // TODO : bazen url tam olarak gelmiyor
                  image: NetworkImage(auth.currentUser.photoURL),
                ),
              ),
              accountEmail: Text(
                auth.currentUser.email,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              accountName: Text(
                auth.currentUser.displayName,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("navbar"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BottomNavbar()));

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("home screen"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen(),
                  ),
                );

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("firebasetryscreen"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FireBaseTryScreen(),
                  ),
                );

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Çıkış Yap"),
              onTap: () async {
                await auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(context),
      appBar: AppBar(
        actions: [
          buildRingBell(context),
          buildHomeworkButton(context),
        ],
        title: Text(auth.currentUser.displayName),
      ),
      body: body,
    );
  }
}
