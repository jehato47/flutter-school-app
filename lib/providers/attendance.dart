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

  DateTime date;
  String baseUrl = Envs.baseUrl;
  String currentTime;
  String currentClass;
  Map attendance = {
    "gelenler": [],
    "gelmeyenler": [],
    "gecGelenler": [],
    "izinliler": [],
  };

  var _studentList;
  var _attendanceList;

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

  Future<void> sendAttendance(
      Map<String, dynamic> attendanceMap, String token) async {
    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl + "/manage/addattendance"),
        headers: headers,
        body: json.encode(attendanceMap),
      );
      // print(response.body);
    } catch (err) {
      print(err);
    }
  }

  Future<dynamic> getAttendance() async {
    CollectionReference syllabus =
        FirebaseFirestore.instance.collection('syllabus');
    QuerySnapshot response = await syllabus.get();
    QueryDocumentSnapshot syl = response.docs[0];
    Map<Duration, String> map = {};
    List<Duration> liste = [];
    Intl.defaultLocale = 'en_EN';
    final day = DateFormat("EEEE").format(DateTime.now()).toLowerCase();

    syl[day].forEach((classFirst, timestamp) {
      DateTime date = DateTime.now();
      map[timestamp.toDate().difference(date)] = classFirst;
      liste.add(timestamp.toDate().difference(date));
    });
    liste.sort();

    String classFirst = map[liste.first].split("-").first;
    String classLast = map[liste.first].split("-").last;

    QuerySnapshot students = await FirebaseFirestore.instance
        .collection("students")
        .where('classFirst', isEqualTo: classFirst)
        .where("classLast", isEqualTo: classLast)
        .get();
    return students.docs;
  }

  Future<void> getNearestAttendanceWithDetails(
    String token,
    String datee,
    String time,
    String clss,
  ) async {
    if (clss == "") {
      datee = "0";
      time = "0";
      clss = "0";
    }
    var headers = {
      "Authorization": "Token $token",
    };
    _studentList = null;
    currentClass = "";
    currentTime = null;
    _classes = null;
    date = null;
    _oldAttendance = null;

    final response = await http.get(
        Uri.parse(baseUrl + "/manage/getattdtl/$datee/$time/$clss"),
        headers: headers);
    final liste = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(liste);

    if (normalJson["success"] != false) {
      _classes = normalJson["dp"];
      _studentList = normalJson["öğrenciler"];
      currentClass = normalJson["sınıf"].split(" ")[0];
      currentTime = normalJson["sınıf"].split(" ")[1];
      date = DateTime.parse(normalJson["date"]);
      _oldAttendance = normalJson["yoklama"];
    }
  }

  Future<List<dynamic>> getStudents(String cls, String token) async {
    _oldAttendance = {};
    http.Response response;
    var headers = {
      'Authorization': 'Token $token',
      'Content-Type': 'application/json; charset=UTF-8'
    };
    if (cls == "") {
      response = await http.get(
        Uri.parse(baseUrl + "/manage/getnrstatlist"),
        headers: headers,
      );
      final body = utf8.decode(response.bodyBytes);
      final normalJson = json.decode(body);
      cls = normalJson["sınıf"].split(" ").first;
    }

    response = await http.get(
      Uri.parse(
        baseUrl + "/student/class/$cls",
      ),
      headers: headers,
    );

    final liste = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(liste) as List;

    // if (oldAttendance["success"] != false) print(122);
    _studentList = normalJson;

    return _studentList;
  }

  Future<void> getAll(String token) async {
    var headers = {'Authorization': 'Token $token'};

    final response = await http.get(
      Uri.parse(baseUrl + "/manage/attendance"),
      headers: headers,
    );
    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse) as List<dynamic>;
    _attendanceList = normalJson;
  }

  Future<List<dynamic>> getAttendanceByClass(
      String token, String classToGet) async {
    var headers = {"Authorization": "Token $token"};
    final response = await http.get(
      Uri.parse(baseUrl + "/manage/attendance/$classToGet"),
      headers: headers,
    );
    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse) as List<dynamic>;

    return normalJson;
  }

  Future<void> getAllClassNamesForAttendancePreview(String token) async {
    var headers = {
      'Authorization': 'Token $token',
    };

    final response = await http.get(
      Uri.parse(baseUrl + "/manage/getallclss"),
      headers: headers,
    );

    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse);
    _allClasses = normalJson;
  }

  // // Öğretmenin en yakın zamanlı ders programını alıyor
  // Future<void> getCurrentClassAndTime(String token) async {
  //   currentClass = "";
  //   currentTime = "";
  //   http.Response response;
  //   var headers = {
  //     'Authorization': 'Token $token',
  //     'Content-Type': 'application/json; charset=UTF-8'
  //   };

  //   response = await http.get(
  //     baseUrl + "/manage/getnrstatlist",
  //     headers: headers,
  //   );

  //   final body = utf8.decode(response.bodyBytes);
  //   final normalJson = json.decode(body);
  //   if (normalJson["sınıf"] != null) {
  //     currentClass = normalJson["sınıf"].split(" ").first;
  //     currentTime = normalJson["sınıf"].split(" ").last;
  //   }
  // }

  // Future<dynamic> getOldAttendanceList(
  //   String token,
  //   String date,
  //   String lecture,
  //   String time,
  //   String clss,
  // ) async {
  //   await getCurrentClassAndTime(token);
  //   print(currentClass);
  //   print(currentTime);
  //   var headers = {
  //     "Authorization": "Token $token",
  //   };
  //   print(baseUrl + "/manage/attendance/$date/$lecture/$time/$clss");
  //   final response = await http.get(
  //     baseUrl + "/manage/attendance/$date/$lecture/$time/$clss",
  //     headers: headers,
  //   );
  //   final normalResponse = utf8.decode(response.bodyBytes);
  //   final normalJson = json.decode(normalResponse);
  //   _oldAttendance = normalJson;
  //   // print(normalJson);
  //   return _oldAttendance;
  // }

  // Future<void> getClassesForAttendaceCheck(String token) async {
  //   var headers = {
  //     'Authorization': 'Token $token',
  //   };

  //   final response = await http.get(
  //     baseUrl + "/teacher/gtclss",
  //     headers: headers,
  //   );

  //   final normalResponse = utf8.decode(response.bodyBytes);
  //   final normalJson = json.decode(normalResponse);

  //   _classes = normalJson;
  // }
}
