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
    bool isStudentDeleted = widget.student["username"] == "deleted";
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://schoolapi.pythonanywhere.com" + student["profil_foto"],
              ),
            ),
            title: Text(
              student["isim"] + " " + student["soyisim"],
            ),
            subtitle: Text(student["sınıf"].toString() + "-" + student["şube"]),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "veli telefon numarası : " + student["veli_tel"],
                    ),
                  ),
                  // Expanded(child: SizedBox(height: 5)),
                  Expanded(
                    child: Text(
                      "öğrenci telefon numarası : " + student["tel"],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Email : " + student["email"],
                    ),
                  ),
                  if (isStudentDeleted)
                    Expanded(
                      child: Text(
                        "Öğrenci kaydı silinmiş",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
