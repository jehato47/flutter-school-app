import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance.dart';

class SendButton extends StatefulWidget {
  final attendance;
  final token;
  SendButton(this.attendance, this.token);
  @override
  _SendButtonState createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator()
        : ElevatedButton(
            onPressed: () async {
              print(widget.token);
              setState(() {
                isLoading = true;
              });
              await Provider.of<Attendance>(context)
                  .sendAttendance(widget.attendance, widget.token);
              setState(() {
                isLoading = false;
              });

              await Future.delayed(Duration(seconds: 2)).then(
                (value) {
                  Navigator.of(context).pop();
                },
              );
            },
            child: Text("gönder"),
          );
  }
}
