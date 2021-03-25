import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'dart:math';
import 'register_etude_popup.dart';
import 'package:provider/provider.dart';
import '../../providers/etude.dart';
import '../../providers/auth.dart';
import '../../helpers/resource_view/shiftdatasource.dart';

class GiveEtudeScreen extends StatefulWidget {
  static const url = "/give-etude";
  @override
  _GiveEtudeScreenState createState() => _GiveEtudeScreenState();
}

class _GiveEtudeScreenState extends State<GiveEtudeScreen> {
  // List<Appointment> _shiftCollection;
  // List<CalendarResource> _employeeCollection;
  List<TimeRegion> _specialTimeRegions;
  ShiftDataSource _events;
  CalendarController _calendarController;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.timelineDay,
    CalendarView.timelineWeek,
    CalendarView.timelineWorkWeek,
    CalendarView.timelineMonth
  ];

  @override
  void initState() {
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.timelineWeek;
    // _employeeCollection = <CalendarResource>[];
    // _shiftCollection = <Appointment>[];
    _specialTimeRegions = <TimeRegion>[];
    // _events = ShiftDataSource(_shiftCollection, _employeeCollection);
    // _addSpecialRegions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    _specialTimeRegions = Provider.of<Etude>(context).addSpecialRegions();
    return Scaffold(
      appBar: AppBar(
        title: Text("Etüt"),
      ),
      body: FutureBuilder(
          future: Provider.of<Etude>(context).getEtudes(token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );

            _events = Provider.of<Etude>(context).setResources();
            return _getShiftScheduler(_events);
          }),
    );
  }

  /// Method that creates the collection the data source for calendar, with
  /// required information.

  Widget _getSpecialRegionWidget(
      BuildContext context, TimeRegionDetails details) {
    if (details.region.text == 'Lunch') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.restaurant_menu,
          color: Colors.grey.withOpacity(0.5),
        ),
      );
    } else if (details.region.text == 'Not Available') {
      return Container(
        color: details.region.color,
        alignment: Alignment.center,
        child: Icon(
          Icons.block,
          color: Colors.grey.withOpacity(0.5),
        ),
      );
    }

    return Container(color: details.region.color);
  }

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getShiftScheduler([
    CalendarDataSource _calendarDataSource,
  ]) {
    return SfCalendar(
      firstDayOfWeek: 1,
      showDatePickerButton: true,
      controller: _calendarController,
      allowedViews: _allowedViews,
      timeRegionBuilder: _getSpecialRegionWidget,
      specialRegions: _specialTimeRegions,
      dataSource: _calendarDataSource,
      onTap: (CalendarTapDetails calendarTapDetails) {
        print(calendarTapDetails.targetElement);
        if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
            calendarTapDetails.targetElement != CalendarElement.appointment) {
          return;
        }
        if (calendarTapDetails.targetElement == CalendarElement.appointment) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RegisterEtudePopUp(
                calendarTapDetails.appointments[0],
              ),
              // fullscreenDialog: true,
            ),
          );
        }
      },
    );
  }
}
