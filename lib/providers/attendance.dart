import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/envs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Attendance extends ChangeNotifier {
  // -- Functions --
  // getStudents
  // sendAttendance
  // getAll

  dynamic _allClasses;
  dynamic _classes;
  Map _oldAttendance;

  // DateTime date;
  String baseUrl = Envs.baseUrl;

  String _currentClass;
  DateTime _currentTime;
  // String currentClass;
  Map attendance = {
    "arrivals": [],
    "notExists": [],
    "lates": [],
    "permitted": [],
  };

  var _studentList;
  var _attendanceList;

  get currentClass {
    return _currentClass;
  }

  get currentTime {
    return _currentTime;
  }

  get students {
    return [..._studentList];
  }

  get attendanceList {
    return _attendanceList;
  }

  get allClasses {
    return _allClasses;
  }

  get classes {
    return _classes;
  }

  get oldAttendance {
    return _oldAttendance;
  }

  Future<void> sendAttendance() async {}

  Future<dynamic> getAttendance() async {
    CollectionReference syllabus =
        FirebaseFirestore.instance.collection('syllabus');
    QuerySnapshot response = await syllabus.get();
    QueryDocumentSnapshot syl = response.docs[0];
    Map<Duration, String> map = {};
    List<Duration> liste = [];
    DateTime date = DateTime.now();

    syl["monday"].forEach((key, value) {
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

    String classFirst = map[liste.first].split("-").first;
    String classLast = map[liste.first].split("-").last;

    _currentClass = map[liste.first];
    DateTime dateInSyllabus = syl["monday"][map[liste.first]].toDate();
    _currentTime = DateTime(
      date.year,
      date.month,
      date.day,
      dateInSyllabus.hour,
      dateInSyllabus.minute,
    );

    // / ?TODO : Bunu baska bir fonksiyonda yap ve işlevsel hale getir
    // / ?TODO : Kendisi otomatik almasın
    CollectionReference att = FirebaseFirestore.instance
        .collection('attendance/pieces/$_currentClass');
    final att2 = await att.doc(_currentTime.toString()).get();
    if (att2.exists)
      attendance = att2["info"];
    else {
      attendance = null;
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
