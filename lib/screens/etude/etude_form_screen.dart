import 'package:flutter/material.dart';
import '../../widgets/etude/etude_form/second_step_etude_form.dart';
import '../../helpers/help.dart';

class EtudeFormScreen extends StatefulWidget {
  static const url = "etude-form";
  @override
  _EtudeFormScreenState createState() => _EtudeFormScreenState();
}

class _EtudeFormScreenState extends State<EtudeFormScreen> {
  @override
  Widget build(BuildContext context) {
    final lecture = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text("$lecture Etüt Formu".capitalizeFirstofEach),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SecondStepEtudeForm(lecture),
      ),
    );
  }
}
