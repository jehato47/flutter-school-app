import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

String _getMonthDate(int month) {
  if (month == 01) {
    return 'Ocak';
  } else if (month == 02) {
    return 'Şubat';
  } else if (month == 03) {
    return 'Mart';
  } else if (month == 04) {
    return 'Nisan';
  } else if (month == 05) {
    return 'Mayıs';
  } else if (month == 06) {
    return 'Haziran';
  } else if (month == 07) {
    return 'Temmuz';
  } else if (month == 08) {
    return 'Ağustos';
  } else if (month == 09) {
    return 'Eylül';
  } else if (month == 10) {
    return 'Ekim';
  } else if (month == 11) {
    return 'Kasım';
  } else {
    return 'Aralık';
  }
}

Widget scheduleViewBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthDate(details.date.month);
  return Stack(
    children: [
      Image(
          image: ExactAssetImage('images/' + monthName + '.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 20,
        bottom: 0,
        child: Text(
          monthName + ' ' + details.date.year.toString(),
          style: TextStyle(
            fontSize: 18,
            color: Colors.black45,
          ),
        ),
      )
    ],
  );
}

class TimetableDataSource extends CalendarDataSource {
  TimetableDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].subject;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
