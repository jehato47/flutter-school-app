import 'package:syncfusion_flutter_calendar/calendar.dart';

class ShiftDataSource extends CalendarDataSource {
  ShiftDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}
