import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
import '../../providers/timetable.dart';
import '../../helpers/timetable/timetable_helpers.dart';
import '../../screens/attendance/attendace_check_screen.dart';

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
      // timeZone: "Turkey Standard Time",
      firstDayOfWeek: 1,
      allowedViews:
          widget.isTeacher ? _allowedViewsTeacher : _allowedViewsStudent,
      onTap: (calendarTapDetails) {
        if (calendarTapDetails.appointments == null) return;
        calendarTapDetails.appointments.forEach((element) {
          // print(element.startTime);
          // print(DateTime.now());
          // print(calendarTapDetails.targetElement);
          // Eğer tıkladığımız appointment sınıfı gösteriyorsa
          // yoklamasına git diyoruz
          DateTime date = calendarTapDetails.date;

          if (widget.isTeacher &&
              calendarTapDetails.targetElement == CalendarElement.appointment &&
              element.subject.contains("-")) {
            Appointment apt = calendarTapDetails.appointments[0];
            // return;
            Navigator.of(context).pushReplacementNamed(
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
          }

          // print(element.startTime);
          // print(element.subject);
          // setState(() {
          //   _appointments.removeWhere(
          //     (v) => v.subject == element.subject,
          //   );
          // });
        });
      },
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showNavigationArrow: true,
      showDatePickerButton: true,
      view: widget.isTeacher ? CalendarView.week : CalendarView.month,

      scheduleViewSettings: ScheduleViewSettings(
        // dayHeaderSettings: DayHeaderSettings(
        //   dayTextStyle: TextStyle(),
        // ),
        hideEmptyScheduleWeek: true,
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
        startHour: 7,
        endHour: 24,
        // nonWorkingDays: <int>[DateTime.friday, DateTime.saturday],
      ),
      dataSource: TimetableDataSource(
        Provider.of<Timetable>(context, listen: false)
            .createAppointments(widget.isTeacher),
      ),
      monthViewSettings: MonthViewSettings(
        // appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
        // navigationDirection: MonthNavigationDirection.horizontal,

        monthCellStyle: MonthCellStyle(),
        numberOfWeeksInView: 6,
        showAgenda: true,
        // appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }
}
