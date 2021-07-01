import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school2/firebase/firebase.dart';
import 'package:school2/widgets/home/student_home_screen.dart';
import 'package:school2/widgets/home/teacher_home_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/notification.dart';
import 'providers/timetable.dart';
import 'providers/attendance.dart';
import 'providers/auth.dart';
import 'providers/homework.dart';
import 'providers/exam.dart';
import 'providers/etude.dart';
import 'providers/local_notification/local_notification.dart';
import 'screens/notifications/notification_screen.dart';
import 'screens/exam/student_exam_screen.dart';
import 'screens/homework/homework_detail_screen.dart';
import 'screens/homework/homework_preview_screen.dart';
import 'screens/timetable/teacher_timetable_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/attendance/attendance_detail_screen.dart';
import 'screens/attendance/attendance_preview_screen.dart';
import 'screens/attendance/attendace_check_screen.dart';
import 'screens/homework/give_homework_screen.dart';
import 'screens/timetable/student_timetable_screen.dart';
import 'screens/exam/add_exam_result_screen.dart';
import 'screens/etude/etude_requests_screen.dart';
import 'screens/etude/select_lecture_screen.dart';
import 'screens/etude/etude_form_screen.dart';
import 'screens/etude/my_etudes_screen.dart';
import 'screens/etude/etude_chat_screen.dart';
import 'helpers/download/download_helper_provider.dart';
import 'screens/exam/exams_list_screen.dart';
import 'screens/archive/teacher_archive_screen.dart';
import 'widgets/home/bottom_navbar.dart';
import 'screens/login/login_screen2.dart';
import 'screens/archive/archive_preview_screen.dart';
import 'screens/myclass/my_friends_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb)
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
  Intl.defaultLocale = 'tr_TR';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => Download(),
        ),
        ChangeNotifierProvider(
          create: (context) => Attendance(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeWork(),
        ),
        ChangeNotifierProvider(
          create: (context) => Timetable(),
        ),
        ChangeNotifierProvider(
          create: (context) => Exam(),
        ),
        ChangeNotifierProvider(
          create: (context) => Etude(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationP(),
        ),
        ChangeNotifierProvider(
          create: (context) => PushNotification(),
        ),
      ],
      child: MaterialApp(
        // theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
            // primaryColorDark: Colors.red,
            // brightness: Brightness.dark,
            // accentColor: Colors.amber,
            // buttonColor: Colors.indigo,
            ),
        themeMode: ThemeMode.light,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          // ... app-specific localization delegate[s] here
          SfGlobalLocalizations.delegate
        ],
        // ignore: always_specify_types
        supportedLocales: const [
          Locale('en'),
          Locale('tr'),
          // ... other locales the app supports
        ],
        locale: const Locale('tr'),
        debugShowCheckedModeBanner: false,
        title: 'school2',
        theme: ThemeData(
          // fontFamily: "ruda",
          // primaryColor: Colors.indigo,
          primaryTextTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.white,
                ),
              ),
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // fontFamily: "quicksand",
        ),

        home: Scaffold(
          body: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return StreamBuilder(
                // TODO: login, logout, signup yapıldıgında bu stream değişecek
                // TODO: onAuthstateChanged -> authStateChanges
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  // FirebaseAuth.instance.signOut();
                  // * TODO : Login Form da setState hatası veriyor bak
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasData) {
                    User user = snapshot.data;
                    // ? todo : Sınav cevap kağıdını göstermeyi hallet

                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("user")
                            .doc(user.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          DocumentSnapshot documentSnapshot = snapshot.data;
                          Provider.of<Auth>(context, listen: false).userInfo =
                              documentSnapshot.data();
                          if (documentSnapshot["role"] == "teacher")
                            return TeacherHomeScreen();
                          return StudentHomeScreen();
                        });
                  }
                  return LoginScreen();
                },
              );
            },
          ),
        ),
        routes: {
          LoginScreen.url: (ctx) => LoginScreen(),
          AttendanceCheckScreen.url: (ctx) => AttendanceCheckScreen(),
          AttendancePreviewScreen.url: (ctx) => AttendancePreviewScreen(),
          AttendanceDetailScreen.url: (ctx) => AttendanceDetailScreen(),
          GiveHomeworkScreen.url: (ctx) => GiveHomeworkScreen(),
          HomeworkPreviewScreen.url: (ctx) => HomeworkPreviewScreen(),
          HomeWorkDetailScreen.url: (ctx) => HomeWorkDetailScreen(),
          TeacherTimetableScreen.url: (ctx) => TeacherTimetableScreen(),
          StudentTimetableScreen.url: (ctx) => StudentTimetableScreen(),
          AddExamResultScreen.url: (ctx) => AddExamResultScreen(),
          StudentExamScreen.url: (ctx) => StudentExamScreen(),
          EtudeRequestsScreen.url: (ctx) => EtudeRequestsScreen(),
          NotificationScreen.url: (ctx) => NotificationScreen(),
          ExamsListScreen.url: (ctx) => ExamsListScreen(),
          SelectLectureScreen.url: (ctx) => SelectLectureScreen(),
          MyEtudesScreen.url: (ctx) => MyEtudesScreen(),
          EtudeChatScreen.url: (ctx) => EtudeChatScreen(),
          EtudeFormScreen.url: (ctx) => EtudeFormScreen(),
          TeacherArchiveScreen.url: (ctx) => TeacherArchiveScreen(),
          ArchivePreviewScreen.url: (ctx) => ArchivePreviewScreen(),
          MyFriendsScreen.url: (ctx) => MyFriendsScreen(),
        },
      ),
    );
  }
}
