import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';
import '../helpers/envs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Timetable extends ChangeNotifier {
  // -- Functions --
  // addAppointment
  // addRecursiveAppointment
  // setTeacherTimetables
  // setStudentTimetables
  // createStudentTimeTable
  // createTeacherTimeTable
  // createAppointments
  final baseUrl = Envs.baseUrl;
  Map<String, dynamic> days = {
    "monday": WeekDays.monday,
    "tuesday": WeekDays.tuesday,
    "wednesday": WeekDays.wednesday,
    "thursday": WeekDays.thursday,
    "friday": WeekDays.friday,
    "saturday": WeekDays.saturday,
    "sunday": WeekDays.sunday,
  };

  List<Color> colorCollection = [
    const Color(0xFF0F8644),
    const Color(0xFF8B1FA9),
    const Color(0xFFD20100),
    const Color(0xFFFC571D),
    const Color(0xFF36B37B),
    const Color(0xFF01A1EF),
    const Color(0xFF3D4FB5),
    const Color(0xFFE47C73),
    const Color(0xFF636363),
    const Color(0xFF0A8043),
  ];

  final Random random = Random();
  List<Appointment> _appointments;
  Map<String, dynamic> teacherData;
  Map<String, dynamic> studentData;

  Future<void> teacherTimeTable() async {}

  Future<void> setTeacherTimetables(
    // TODO : Tek bir kez çalışmasını sağla
    String token,
    dynamic userInfo,
  ) async {
    CollectionReference syllabus =
        FirebaseFirestore.instance.collection("syllabus");

    QuerySnapshot snapshot = await syllabus.get();
    teacherData = snapshot.docs[0].data();
  }

  Future<void> setStudentTimetables(String token, dynamic userInfo) async {}

  List<Appointment> createAppointments(bool isTeacher) {
    _appointments = [];

    DateTime date = DateTime.now();
    addAppointment(
      date,
      date.add(Duration(minutes: 50)),
      "etüt",
      WeekDays.friday,
    );
    if (isTeacher)
      createTeacherTimeTable();
    else {
      createStudentTimeTable();
    }
    return _appointments;
  }

  void addAppointment(
      DateTime startTime, DateTime endTime, String subject, WeekDays day) {
    // DateTime.now() türkiye zamanını almıyor. Bak.
    _appointments.add(
      Appointment(
        subject: subject,
        startTime: startTime,
        endTime: endTime,
        color: colorCollection[random.nextInt(9)],
        isAllDay: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=7',
      ),
    );
  }

  void createStudentTimeTable() {
    var today = DateTime.now();

    days.forEach((day, weekday) {
      studentData[day].forEach((key, value) {
        var k = key.split("-");
        DateTime startTime = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(k[0]),
          int.parse(k[1]),
        ).subtract(Duration(days: 180));
        DateTime endTime = startTime.add(Duration(minutes: 40));

        var subject = "${value.values.last} - ${value.keys.last}";
        addRecursiveAppointment(startTime, endTime, subject, weekday);
      });
    });
  }

  Future<void> createTeacherTimeTable() async {
    teacherData.forEach((day, value) {
      value.forEach((clss, timestamp) {
        addRecursiveAppointment(timestamp.toDate(),
            timestamp.toDate().add(Duration(minutes: 40)), clss, days[day]);
      });
    });
  }

  void addRecursiveAppointment(
      DateTime startTime, DateTime endTime, String subject, WeekDays day) {
    final Appointment weeklyAppointment = Appointment();

    weeklyAppointment.startTime = startTime;
    weeklyAppointment.endTime = endTime;
    weeklyAppointment.color = colorCollection[random.nextInt(9)];
    weeklyAppointment.subject = subject;

    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties();
    recurrencePropertiesForWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForWeeklyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForWeeklyAppointment.interval = 1;
    recurrencePropertiesForWeeklyAppointment.weekDays = <WeekDays>[]..add(day);
    recurrencePropertiesForWeeklyAppointment.recurrenceCount = 54;
    weeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
      recurrencePropertiesForWeeklyAppointment,
      weeklyAppointment.startTime,
      weeklyAppointment.endTime,
    );
    _appointments.add(weeklyAppointment);
  }
}
