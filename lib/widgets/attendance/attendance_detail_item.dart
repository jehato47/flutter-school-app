import 'package:flutter/material.dart';

class AttendanceDetailItem extends StatefulWidget {
  final dynamic student;

  AttendanceDetailItem(this.student);

  @override
  _AttendanceDetailItemState createState() => _AttendanceDetailItemState();
}

class _AttendanceDetailItemState extends State<AttendanceDetailItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    // Eğer öğrenci daha sonra silinmiş olsa bile bilgileri gösterilecek
    // bool isStudentDeleted = widget.student["name"] == "deleted";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          // leading: CircleAvatar(
          //   backgroundImage: NetworkImage(
          //     "https://schoolapi.pythonanywhere.com" + student["profil_foto"],
          //   ),
          // ),
          title: Text(
            student["name"] + " " + student["surname"],
          ),
          subtitle: Text(
              student["classFirst"].toString() + "-" + student["classLast"]),
          trailing: IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
        ),
        AnimatedContainer(
          width: double.infinity,
          height: isExpanded ? 90 : 0,
          duration: Duration(milliseconds: 200),
          // color: Colors.black38,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "veli telefon numarası : " + student["parentNumber"],
                  ),
                ),
                // Expanded(child: SizedBox(height: 5)),
                Expanded(
                  child: Text(
                    "öğrenci telefon numarası : " + student["parentNumber"],
                  ),
                ),
                // Expanded(
                //   child: Text(
                //     "Email : " + student["email"],
                //   ),
                // ),
                // if (isStudentDeleted)
                //   Expanded(
                //     child: Text(
                //       "Öğrenci kaydı silinmiş",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         color: Colors.amber,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1),
      ],
    );
  }
}
