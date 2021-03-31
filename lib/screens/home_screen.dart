import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school2/screens/homework/give_homework_screen.dart';
import '../providers/auth.dart';
import '../widgets/home/pages_grid.dart';
import '../screens/notifications/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  static const url = "home";

  Widget buildRingBell(BuildContext context) {
    int number;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("notification")
            .where("isSeen", isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final docs = snapshot.data.documents;
          number = docs.length;
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
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
                  width: number >= 10 ? 20 : 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red,
                  ),
                  child: Text(
                    number.toString(),
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
          color: Colors.indigo,
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(GiveHomeworkScreen.url);
          },
        ),
      ),
    );
  }

  Widget buildDrawer(dynamic user) {
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
                  image: NetworkImage(user["profil_foto"]),
                ),
              ),
              accountEmail: Text(
                user["email"],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              accountName: Text(
                user["isim"] + " " + user["soyisim"],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).userInform;
    return Scaffold(
      drawer: buildDrawer(user),
      appBar: AppBar(
        actions: [
          buildRingBell(context),
          buildHomeworkButton(context),
        ],
        title: Text(user["isim"] + " " + user["soyisim"]),
      ),
      body: PagesGrid(),
    );
  }
}
