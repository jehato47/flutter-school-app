import 'package:flutter/material.dart';
import '../../providers/auth.dart';
import 'package:provider/provider.dart';
import '../../providers/exam.dart';
import '../../helpers/datagrid/sinav_data_grid_source.dart';
import '../../widgets/exam/student_exam_data_grid.dart';

class StudentExamScreen extends StatelessWidget {
  static const url = "/student-exam";

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<Auth>(context).token;
    return Scaffold(
      // backgroundColor: Color.fromRGBO(35, 35, 35, 1),
      appBar: AppBar(
        title: Text("Öğrenci Sonuç"),
      ),
      body: FutureBuilder(
        future: Provider.of<Exam>(
          context,
          listen: false,
        ).getStudentResults(token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final _sinavDataGridSource = SinavDataGridSource(snapshot.data);
          return StudentExamDataGrid(_sinavDataGridSource);
        },
      ),
    );
  }
}
