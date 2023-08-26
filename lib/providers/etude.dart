import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../helpers/resource_view/shiftdatasource.dart';
import 'dart:math';
import '../helpers/envs.dart';

class Etude extends ChangeNotifier {
  // -- Functions --
  // getEtudes
  // enrollToEtude
  // addSpecialRegions
  // setAppointments
  // setCalendarResources
  // setResources

  List<Color> colorCollection = [
    const Color(0xFFD20100),
    const Color(0xFFFC571D),
    const Color(0xFF8B1FA9),
    const Color(0xFF3D4FB5),
    const Color(0xFF01A1EF),
    const Color(0xFFE47C73),
    const Color(0xFF636363),
    const Color(0xFF0F8644),
    const Color(0xFF0A8043),
    const Color(0xFF36B37B),
  ];
  Map<String, dynamic> days = {
    "pazartesi": DateTime.monday,
    "salı": DateTime.tuesday,
    "çarşamba": DateTime.wednesday,
    "perşembe": DateTime.thursday,
    "cuma": DateTime.friday,
    "cumartesi": DateTime.saturday,
    "pazar": DateTime.sunday,
  };

  final baseUrl = Envs.baseUrl;
  List<TimeRegion> _specialTimeRegions = [];
  List<CalendarResource> _calendarResources = [];
  List<Appointment> _appointments = [];
  List<dynamic> _etudes;
  Random random = Random();

  get calendarResources {
    return [..._calendarResources];
  }

  get appointments {
    return [..._appointments];
  }

  Future<void> getEtudes(String token) async {
    _appointments = [];
    _calendarResources = [];
    var headers = {"Authorization": "Token $token"};
    final response = await http.get(
      Uri.parse(baseUrl + "/teacher/gettbylec/matematik"),
      headers: headers,
    );

    final normalResponse = utf8.decode(response.bodyBytes);
    final normalJson = json.decode(normalResponse) as List<dynamic>;
    // print(normalJson);
    _etudes = normalJson;
  }

  ShiftDataSource setResources() {
    setAppointments();
    setCalendarResources();
    return ShiftDataSource(_appointments, _calendarResources);
  }

  void setCalendarResources() {
    _etudes.forEach((element) {
      if (element["etüt_saatleri"].length != 0) {
        _calendarResources.add(
          CalendarResource(
            id: element["user"].toString(),
            color: colorCollection[random.nextInt(8)],
            displayName: element["isim"] + " " + element["soyisim"],
            image: NetworkImage(
              baseUrl + element["profil_foto"],
            ),
          ),
        );
      }
      print(calendarResources);
    });
  }

  void setAppointments() {
    var today = DateTime.now();

    _etudes.forEach((teacher) {
      if (teacher["etüt_saatleri"].length == 0) {
        return;
      }

      days.forEach((day, weekday) {
        var etutDay = teacher["etüt_saatleri"][day] as Map<String, dynamic>;

        etutDay.forEach((key, value) {
          value["teacher_name"] = teacher["isim"] + " " + teacher["soyisim"];
          value["teacher_id"] = teacher["user"].toString();

          var startTime = DateTime(
            today.year,
            today.month,
            today.day + days[day] - 1,
            int.parse(key),
          );

          value["day"] = day;
          _appointments.add(
            Appointment(
              color: colorCollection[random.nextInt(8)],
              resourceIds: [teacher["user"].toString()],
              subject: "Elektroliz",
              startTime: startTime,
              endTime: startTime.add(const Duration(minutes: 40)),
              notes: json.encode(value),
            ),
          );
        });
      });
    });
  }

  Future<void> enrollToEtude(
    String token,
    Map etude,
    String day,
    String hour,
    Map info,
    int user,
  ) async {
    var headers = {
      "Authorization": "Token $token",
      'Content-Type': 'application/json'
    };

    // TODO : Error handling'e bak
    if (info["no"] == null) return;

    etude[info["no"].toString()] = info["isim"] + " " + info["soyisim"];
    var body = json.encode({
      "user_id": user,
      "gün": day,
      "etüt": {
        hour: etude,
      },
    });

    await http.put(
      Uri.parse(baseUrl + "/manage/updet"),
      headers: headers,
      body: body,
    );

    notifyListeners();
  }

  List<TimeRegion> addSpecialRegions() {
    _specialTimeRegions = [];
    final DateTime date = DateTime.now();
    // Random random = Random();
    for (int i = 0; i < _calendarResources.length; i++) {
      final DateTime startDate = DateTime(date.year, date.month, date.day, 16);

      _specialTimeRegions.add(
        TimeRegion(
          startTime: startDate,
          endTime: startDate.add(Duration(hours: 1)),
          text: 'Lunch',
          color: Colors.grey.withOpacity(0.2),
          enablePointerInteraction: false,
          resourceIds: <Object>[_calendarResources[i].id],
          recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
        ),
      );
    }

    return _specialTimeRegions;
  }
}
