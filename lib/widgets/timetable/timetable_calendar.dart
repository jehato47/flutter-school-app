import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../screens/etude/etude_chat_screen.dart';
import '../../screens/etude/in_etude_chat_screen.dart';
import '../../screens/homework/homework_detail_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../providers/timetable.dart';
import '../../helpers/timetable/timetable_helpers.dart';
import '../../screens/attendance/attendace_check_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TimetableCalendar extends StatefulWidget {
  final bool isTeacher;
  TimetableCalendar({this.isTeacher = false});

  @override
  _TimetableCalendarState createState() => _TimetableCalendarState();
}

class _TimetableCalendarState extends State<TimetableCalendar> {
  final List<CalendarView> _allowedViewsStudent = <CalendarView>[
    CalendarView.schedule,
    CalendarView.month,
  ];
  final List<CalendarView> _allowedViewsTeacher = <CalendarView>[
    // CalendarView.schedule,
    CalendarView.month,
    CalendarView.week,
  ];
  @override
  Widget build(BuildContext context) {
    // dynamic teacherData = widget.teacherData;
    return SfCalendar(
      // * TODO : Timezone olayını hallet
      timeZone: "Turkey Standard Time",
      firstDayOfWeek: 1,
      allowedViews:
          widget.isTeacher ? _allowedViewsTeacher : _allowedViewsStudent,
      onTap: (calendarTapDetails) async {
        if (calendarTapDetails.appointments == null) return;

        for (var element in calendarTapDetails.appointments) {
          // print(element.startTime);
          // print(DateTime.now());
          // print(calendarTapDetails.targetElement);
          // Eğer tıkladığımız appointment sınıfı gösteriyorsa
          // yoklamasına git diyoruz
          DateTime date = calendarTapDetails.date;

          if (widget.isTeacher &&
              calendarTapDetails.targetElement == CalendarElement.appointment &&
              element.notes == "teachertimetable") {
            Appointment apt = calendarTapDetails.appointments[0];
            // return;
            Navigator.of(context).pushNamed(
              AttendanceCheckScreen.url,
              arguments: {
                "class": element.subject,
                "date": DateTime(
                  date.year,
                  date.month,
                  date.day,
                  apt.startTime.hour,
                  apt.startTime.minute,
                ),
              },
            );
          } else if (calendarTapDetails.targetElement ==
                  CalendarElement.appointment &&
              element.notes.startsWith("homework")) {
            // print(122);
            print(element.notes);
            final doc =
                await FirebaseFirestore.instance.doc(element.notes).get();
            // print(doc.data());
            Navigator.of(context)
                .pushNamed(HomeWorkDetailScreen.url, arguments: doc);
          } else if (calendarTapDetails.targetElement ==
                  CalendarElement.appointment &&
              element.notes.startsWith("etude")) {
            final id = element.notes.split("/").last;

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InEtudeChatScreen(id),
            ));
          }
        }
      },
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showNavigationArrow: true,
      showDatePickerButton: true,
      view: widget.isTeacher ? CalendarView.week : CalendarView.month,
      scheduleViewSettings: const ScheduleViewSettings(
        // dayHeaderSettings: DayHeaderSettings(
        //   dayTextStyle: TextStyle(),
        // ),
        hideEmptyScheduleWeek: true,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 7,
        endHour: 24,
        // nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
      ),
      dataSource: TimetableDataSource(
        Provider.of<Timetable>(context, listen: false)
            .createAppointments(widget.isTeacher),
      ),
      appointmentTimeTextFormat: "HH:mm",
      monthViewSettings: const MonthViewSettings(
        // showTrailingAndLeadingDates: false,
        // appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        // navigationDirection: MonthNavigationDirection.horizontal,
        // dayFormat: "E",

        // monthCellStyle: MonthCellStyle(),
        numberOfWeeksInView: 6,
        showAgenda: true,
        // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }
}
