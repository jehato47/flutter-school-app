import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
// import '../models/http_exceptions.dart';

class Attendance extends ChangeNotifier {
  dynamic _classes;
  Map _oldAttendance;
  String _currentClass;
  DateTime _currentTime;

  Map attendance = {
    "arrivals": [],
    "notExists": [],
    "lates": [],
    "permitted": [],
  };

  var _studentList;

  set setCurrentClass(String val) {
    _currentClass = val;
  }

  set setCurrentTime(DateTime val) {
    _currentTime = val;
  }

  get currentClass {
    return _currentClass;
  }

  get currentTime {
    return _currentTime;
  }

  get students {
    return [..._studentList];
  }

  get oldAttendance {
    return _oldAttendance;
  }

  get classes {
    return _classes;
  }

  Future<void> sendAttendance() async {}

  // TODO: Eğer o gün ders yoksa ders yok yazdır
  Future<dynamic> getAttendance([
    String classTimetable,
    DateTime timeTimetable,
  ]) async {
    String classFirst;
    String classLast;
    attendance = null;
    if (timeTimetable != null) {
      _currentTime = timeTimetable;
      _currentClass = classTimetable;
      // CollectionReference att = FirebaseFirestore.instance
      //     .collection('attendance/classes/$currentClass');
      CollectionReference att = FirebaseFirestore.instance
          .collection('attendance/$currentClass/pieces');
      DocumentSnapshot old = await att.doc(_currentTime.toString()).get();

      classFirst = classTimetable.split("-").first;
      classLast = classTimetable.split("-").last;
      if (old.exists) attendance = old["info"];
    } else {
      CollectionReference syllabus =
          FirebaseFirestore.instance.collection('syllabus');
      QuerySnapshot response = await syllabus.get();
      QueryDocumentSnapshot syl = response.docs[0];
      Map<Duration, String> map = {};
      List<Duration> liste = [];
      DateTime date = DateTime.now();
      Intl.defaultLocale = "en_EN";
      String day = DateFormat("EEEE").format(date).toLowerCase();
      Intl.defaultLocale = "tr_TR";

      // TODO : Eğer gelen verinin içinde buradaki gün yoksa hata verir

      if (syl.data()[day].length == 0) {
        // Eğer seçilen günde hiç ders yoksa
        attendance = {};
        return;
      }

      syl[day].forEach((key, value) {
        DateTime sylDate = value.toDate();
        DateTime configuredDate = DateTime(
          date.year,
          date.month,
          date.day,
          sylDate.hour,
          sylDate.minute,
        );

        map[configuredDate.difference(date).abs()] = key;
        liste.add(configuredDate.difference(date).abs());
      });
      liste.sort();

      classFirst = map[liste.first].split("-").first;
      classLast = map[liste.first].split("-").last;

      _currentClass = map[liste.first];
      DateTime dateInSyllabus = syl[day][map[liste.first]].toDate();
      _currentTime = DateTime(
        date.year,
        date.month,
        date.day,
        dateInSyllabus.hour,
        dateInSyllabus.minute,
      );

      // / ?TODO : Bunu baska bir fonksiyonda yap ve işlevsel hale getir
      // / ?TODO : Kendisi otomatik almasın
      // CollectionReference att = FirebaseFirestore.instance
      //     .collection('attendance/classes/$_currentClass');
      CollectionReference att = FirebaseFirestore.instance
          .collection('attendance/$currentClass/pieces');
      final att2 = await att.doc(_currentTime.toString()).get();
      if (att2.exists)
        attendance = att2["info"];
      else {
        attendance = null;
      }
    }
    QuerySnapshot students = await FirebaseFirestore.instance
        .collection("students")
        .where('classFirst', isEqualTo: classFirst)
        .where("classLast", isEqualTo: classLast)
        .get();

    _studentList = students.docs;
    return students.docs;
  }

  Future<void> getAll() async {}

  Future<void> getAttendanceByClass() async {}

  Future<List<QueryDocumentSnapshot>> filterAttendance(
      dynamic startDate, dynamic endDate, String currentClass) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('attendance/$currentClass/pieces')
        .where(
          "date",
          isGreaterThanOrEqualTo: startDate,
          isLessThanOrEqualTo: endDate,
        )
        .orderBy("date", descending: true)
        .get();

    final docs = snapshot.docs;

    return docs;
  }

  Future<dynamic> getOldAttendanceList(String currentClass) async {
    CollectionReference att =
        FirebaseFirestore.instance.collection('attendance');
    final att2 = await att.doc(_currentTime.toString() + currentClass).get();
    if (att2.exists) {
      _oldAttendance = att2["info"];
      return true;
    } else
      return false;
  }
}
