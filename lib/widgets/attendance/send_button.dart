import 'package:flutter/material.dart';

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
    return Container();
  }
}
