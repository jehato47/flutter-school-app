import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../providers/etude.dart';
// import 'package:intl/date_symbol_data_local.dart';

class RegisterEtudePopUp extends StatefulWidget {
  final Appointment appointment;
  RegisterEtudePopUp(this.appointment);

  @override
  _RegisterEtudePopUpState createState() => _RegisterEtudePopUpState();
}

class _RegisterEtudePopUpState extends State<RegisterEtudePopUp> {
  @override
  void initState() {
    // initializeDateFormatting().;
    Intl.defaultLocale = "tr_TR";
    super.initState();
  }

  List<Chip> chips = [];
  String teacherName;
  String day;
  Map notes;
  int teacherUser;
  // print(widget.appointment.notes);
  void createStudentChips() {
    chips = [];
    notes = jsonDecode(widget.appointment.notes);

    // print(notes);
    teacherName = notes["teacher_name"];
    day = notes["day"];
    teacherUser = int.parse(notes["teacher_id"]);

    notes.removeWhere((key, value) =>
        key == "teacher_name" || key == "day" || key == "teacher_id");
    notes.forEach((number, name) {
      chips.add(
        Chip(
          // deleteIcon: Icon(Icons.people),
          backgroundColor: Color.fromRGBO(120, 120, 120, 1),
          padding: EdgeInsets.only(left: 0),
          label: Text(
            name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // deleteIcon: Icon(Icons.delete),
          avatar: Icon(
            Icons.done_all_sharp,
            color: Colors.black,
            // color: Colors.blueGrey[900],
          ),

          onDeleted: () {},
        ),
      );
    });
  }

  void addChip(dynamic info) {
    chips.add(
      Chip(
        // deleteIcon: Icon(Icons.people),
        backgroundColor: Color.fromRGBO(120, 120, 120, 1),
        padding: EdgeInsets.only(left: 0),
        label: Text(
          info["isim"] + " " + info["soyisim"],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // deleteIcon: Icon(Icons.delete),
        avatar: Icon(
          Icons.done_all_sharp,
          color: Colors.black,
        ),

        onDeleted: () {},
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    createStudentChips();
    final token = Provider.of<Auth>(context).token;
    final info = Provider.of<Auth>(context).userInform;
    String hour = widget.appointment.startTime.hour.toString();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Provider.of<Etude>(context)
              .enrollToEtude(token, notes, day, hour, info, teacherUser);

          setState(() {
            addChip(info);
          });
        },
        child: Icon(Icons.schedule_send),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Color.fromRGBO(70, 70, 70, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              addChip(info);
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                widget.appointment.subject,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey,
          ),
          ListTile(
            trailing: Text(
              DateFormat('h:mm a').format(widget.appointment.startTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            title: Text(
              DateFormat('EEE, MMM dd yyyy').format(widget.appointment.endTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            leading: Icon(
              Icons.schedule,
              color: Colors.white,
            ),
          ),
          ListTile(
            trailing: Text(
              DateFormat('h:mm a').format(
                  widget.appointment.startTime.add(Duration(minutes: 40))),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            title: Text(
              DateFormat('EEE, MMM dd yyyy').format(widget.appointment.endTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            leading: Icon(
              Icons.schedule,
              color: Colors.white,
            ),
          ),
          Divider(
            height: 0,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              teacherName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.white,
            ),
            title: chips.length == 0
                ? Text(
                    "Bu etüde henüz kimse kaydolmadı",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  )
                : Wrap(
                    spacing: 10,
                    children: [...chips],
                  ),
          )
        ],
      ),
    );
  }
}
