import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school2/screens/attendance/attendance_preview_screen.dart';
import 'package:school2/widgets/home/teacher_home_screen.dart';
import '../../screens/archive/teacher_archive_screen.dart';
import '../../screens/archive/archive_preview_screen.dart';
import 'bottom_navbar.dart';

import '../../screens/home/home_screen.dart';
import '../../widgets/home/student_home_screen.dart';
import '../../firebase/firebase.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
                backgroundBlendMode: BlendMode.colorDodge,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.pexels.com/photos/7440502/pexels-photo-7440502.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
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
              leading: Icon(
                Icons.archive,
                color: Colors.indigo,
              ),
              title: Text("arşiv"),
              onTap: () {
                Navigator.of(context).pushNamed(
                  TeacherArchiveScreen.url,
                  arguments: auth.currentUser.uid,
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.source,
                color: Colors.indigo,
              ),
              title: Text("kaynaklar"),
              onTap: () {
                Navigator.of(context).pushNamed(
                  ArchivePreviewScreen.url,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("öğretmen"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TeacherHomeScreen(),
                  ),
                );

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("öğrenci"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => StudentHomeScreen(),
                  ),
                );

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_view),
              title: Text("Yoklamalar"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).pushNamed(AttendancePreviewScreen.url);

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
                // await Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => LoginScreen2()));
                await auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
