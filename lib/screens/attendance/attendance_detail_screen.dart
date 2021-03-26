import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../widgets/attendance/attendance_detail_item.dart';

class AttendanceDetailScreen extends StatelessWidget {
  static const url = "/attendance-detail";
  @override
  Widget build(BuildContext context) {
    final attendance =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    bool isEmpty = attendance["gelmeyenler"].isEmpty;
    return Scaffold(
      appBar: AppBar(),
      body: isEmpty
          ? Center(
              child: Text("Gelmeyen öğrenci yokmuş"),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: attendance["gelmeyenler"].length,
                      itemBuilder: (ctx, i) => FutureBuilder(
                        future: Provider.of<Auth>(context).getStudentByNumber(
                          attendance["gelmeyenler"][i],
                        ),
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState ==
                              ConnectionState.waiting)
                            return Image(
                              width: 100,
                              height: 100,
                              image: NetworkImage(
                                "https://media.giphy.com/media/3ov9k0Ziq50EoOuWRi/giphy.gif",
                              ),
                            );
                          return AttendanceDetailItem(
                            snapshot2.data,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
