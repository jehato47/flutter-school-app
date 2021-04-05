import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/notification.dart';
import 'providers/timetable.dart';
import 'providers/attendance.dart';
import 'providers/auth.dart';
import 'providers/homework.dart';
import 'providers/exam.dart';
import 'providers/etude.dart';
import 'screens/notifications/notification_screen.dart';
import 'screens/exam/student_exam_screen.dart';
import 'screens/homework/homework_detail_screen.dart';
import 'screens/homework/homework_preview_screen.dart';
import 'screens/timetable/teacher_timetable_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/attendance/attendance_detail_screen.dart';
import 'screens/attendance/attendance_preview_screen.dart';
import 'screens/attendance/attendace_check_screen.dart';
import 'screens/homework/give_homework_screen.dart';
import 'screens/timetable/student_timetable_screen.dart';
import 'screens/exam/add_exam_result_screen.dart';
import 'screens/etude/give_etude_screen.dart';
import 'firebase/firebase.dart';
import 'helpers/download/download_helper_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  Intl.defaultLocale = 'tr_TR';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<Auth>(context);
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
        title: 'Flutter Demo',
        theme: ThemeData(
          // fontFamily: "quicksand",
          // primaryColor: Colors.indigo,
          primaryTextTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.white,
                ),
              ),
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
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
                  if (snapshot.hasData) {
                    return HomeScreen();
                  }
                  return LoginScreen();
                },
              );
              // FireBaseTryScreen();
              // return Builder(
              //   builder: (context) => Consumer<Auth>(
              //     builder: (context, value, child) {
              //       return value.isAuth
              //           ? HomeScreen()
              //           : FutureBuilder(
              //               future: Provider.of<Auth>(context).login(
              //                 "öğretmen",
              //                 "12345",
              //               ),
              //               builder: (context, snapshot) {
              //                 return LoginScreen();
              //               });
              //     },
              //   ),
              // );
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
          GiveEtudeScreen.url: (ctx) => GiveEtudeScreen(),
          NotificationScreen.url: (ctx) => NotificationScreen(),
        },
      ),
    );
  }
}
