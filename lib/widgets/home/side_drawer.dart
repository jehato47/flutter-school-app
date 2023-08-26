import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/attendance/attendance_preview_screen.dart';
import '../../screens/etude/teacher_etude_screen.dart';
import '../../screens/myclass/my_friends_screen.dart';
import '../../screens/home/teacher_home_screen.dart';
import '../../screens/archive/teacher_archive_screen.dart';
import '../../screens/archive/archive_preview_screen.dart';
import 'bottom_navbar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/student_home_screen.dart';
import '../../firebase/firebase.dart';
import '../../screens/login/login_screen2.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<Auth>(context).userInfo;
    bool isTeacher = userInfo["role"] == "teacher";

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white,
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
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              accountName: Text(
                auth.currentUser.displayName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            if (isTeacher)
              ListTile(
                leading: const Icon(
                  Icons.archive,
                  color: Colors.blue,
                ),
                title: const Text("arşiv"),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    TeacherArchiveScreen.url,
                    arguments: auth.currentUser.uid,
                  );
                },
              ),
            if (isTeacher)
              ListTile(
                leading: const Icon(
                  Icons.source,
                  color: Colors.blue,
                ),
                title: const Text("kaynaklar"),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ArchivePreviewScreen.url,
                  );
                },
              ),
            // if (isTeacher) const Divider(),
            // ListTile(
            //   leading: const Icon(
            //     Icons.person,
            //     color: Colors.blue,
            //   ),
            //   title: const Text("öğretmen"),
            //   onTap: () {
            //     // body = BottomNavbar();

            //     Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => TeacherHomeScreen(),
            //       ),
            //     );

            //     // Navigator.of(context).pop();
            //   },
            // ),
            // ListTile(
            //   leading: Icon(
            //     Icons.person,
            //     color: Colors.blue,
            //   ),
            //   title: Text("öğrenci"),
            //   onTap: () {
            //     // body = BottomNavbar();

            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (BuildContext context) => StudentHomeScreen(),
            //       ),
            //     );

            //     // Navigator.of(context).pop();
            //   },
            // ),
            if (isTeacher) const Divider(),
            // TODO : Öğretmene de sınıf olayını ekle
            if (!isTeacher)
              ListTile(
                leading: const Icon(
                  Icons.groups,
                  color: Colors.blue,
                ),
                title: const Text("sınıfım"),
                onTap: () {
                  Navigator.of(context).pushNamed(MyFriendsScreen.url);
                },
              ),
            ListTile(
              leading: const Icon(
                Icons.grid_view,
                color: Colors.blue,
              ),
              title: Text("Etütlerim"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => TeacherEtudeScreen(),
                  ),
                );

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.reorder,
                color: Colors.blue,
              ),
              title: Text("Yoklamalar"),
              onTap: () {
                // body = BottomNavbar();

                Navigator.of(context).pushNamed(AttendancePreviewScreen.url);

                // Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.grid_view,
                color: Colors.blue,
              ),
              title: const Text("firebasetryscreen"),
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

            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                // color: Colors.blue,
              ),
              title: const Text("Çıkış Yap"),
              onTap: () async {
                Navigator.of(context).pop();
                await auth.signOut();
                //   await Navigator.of(context).push(
                //       MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
