import 'package:flutter/material.dart';
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

  /* Statik Fonksiyonlar  */
  // Future<void> setTeacherTimetables() async {
  //   // TODO : Tek bir kez çalışmasını sağla
  //   CollectionReference syllabus =
  //       FirebaseFirestore.instance.collection("syllabus");
  //   QuerySnapshot snapshot = await syllabus.get();
  //   teacherData = snapshot.docs[0].data();
  // }

  // Future<void> setStudentTimetables() async {
  //   CollectionReference studentsyl =
  //       FirebaseFirestore.instance.collection("studentsyllabus");
  //   QuerySnapshot snapshotst = await studentsyl.get();
  //   studentData = snapshotst.docs[0].data();
  // }

  void createStudentTimeTable() {
    studentData.forEach((day, value) {
      value.forEach((teacher, timestamp) {
        addRecursiveAppointment(
          timestamp.toDate(),
          timestamp.toDate().add(Duration(minutes: 40)),
          teacher,
          days[day],
        );
      });
    });
  }

  Future<void> createTeacherTimeTable() async {
    print(teacherData);
    teacherData.forEach((day, value) {
      value.forEach((clss, timestamp) {
        addRecursiveAppointment(
          timestamp.toDate(),
          timestamp.toDate().add(Duration(minutes: 40)),
          clss,
          days[day],
        );
      });
    });
  }

  List<Appointment> createAppointments(bool isTeacher) {
    _appointments = [];

    // DateTime date = DateTime.now();
    // addAppointment(
    //   date,
    //   date.add(Duration(minutes: 50)),
    //   "etüt",
    //   WeekDays.friday,
    // );

    if (isTeacher)
      createTeacherTimeTable();
    else
      createStudentTimeTable();

    return _appointments;
  }

  /* Dinamik Fonksiyonlar */
  void addAppointment(
      DateTime startTime, DateTime endTime, String subject, WeekDays day) {
    _appointments.add(
      Appointment(
        subject: subject,
        startTime: startTime,
        endTime: endTime,
        color: colorCollection[random.nextInt(9)],
        isAllDay: false,
        // recurrenceRule: 'FREQ=DAILY;INTERVAL=7',
      ),
    );
  }

  void addRecursiveAppointment(
      DateTime startTime, DateTime endTime, String subject, WeekDays day) {
    final Appointment weeklyAppointment = Appointment(
      // startTimeZone: "Belarus Standard Time",
      // endTimeZone: "Belarus Standard Time",

      startTime: startTime.subtract(Duration(days: 180)),
      endTime: endTime.subtract(Duration(days: 180)),
    );

    weeklyAppointment.startTime = startTime.subtract(Duration(days: 180));
    weeklyAppointment.endTime = endTime.subtract(Duration(days: 180));
    weeklyAppointment.color = colorCollection[random.nextInt(9)];
    weeklyAppointment.subject = subject;

    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties(
      startDate: startTime.subtract(
        Duration(days: 180),
      ),
    );
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
