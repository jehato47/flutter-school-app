import 'package:flutter/material.dart';
import '../../widgets/etude/etude_requests/etude_request_list.dart';

class EtudeRequestsScreen extends StatefulWidget {
  static const url = "/etudes-request";
  @override
  _EtudeRequestsScreenState createState() => _EtudeRequestsScreenState();
}

class _EtudeRequestsScreenState extends State<EtudeRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etüt"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: EtudeRequestList(),
      ),
    );
  }
}
