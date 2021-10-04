import 'package:flutter/material.dart';
import '../../widgets/etude/etude_requests/etude_request_list.dart';

class EtudeRequestsScreen extends StatefulWidget {
  static const url = "/give-etude";
  @override
  _EtudeRequestsScreenState createState() => _EtudeRequestsScreenState();
}

class _EtudeRequestsScreenState extends State<EtudeRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etüt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: EtudeRequestList(),
      ),
    );
  }
}
