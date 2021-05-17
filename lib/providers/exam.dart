import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class Exam extends ChangeNotifier {
  Future<void> setDetails(String lecture) async {
    lecture = "fizik";
    List lectures = [
      "fizik",
      "kimya",
      "biyoloji",
      "matematik",
      "dilbilgisi",
      "coğrafya",
      "türkçe",
      "sosyalbilgiler"
    ];

    String fullClass;
    QuerySnapshot studentExams = await FirebaseFirestore.instance
        .collection("exam")
        .where("classFirst", isEqualTo: "11")
        .get();

    final students = studentExams.docs;

    List<dynamic> allClasses = students
        .map((e) => e["classFirst"] + "-" + e["classLast"])
        .toSet()
        .toList();

    dynamic gradeSum = 0;
    dynamic gradeCount = 0;

    dynamic branchSum = 0;
    dynamic branchCount = 0;

    lectures.forEach((lct) {
      lecture = lct;
      allClasses.forEach((clss) {
        fullClass = clss;
        if (students.length != 0)
          students[0][lecture].forEach((which, value) async {
            gradeSum = 0;
            gradeCount = 0;
            branchSum = 0;
            branchCount = 0;
            students.forEach((exam) {
              if (exam[lecture][which] == null) return;
              gradeSum += exam[lecture][which];
              gradeCount += 1;

              if (exam["classFirst"] + "-" + exam["classLast"] == fullClass) {
                branchSum += exam[lecture][which];
                branchCount += 1;
              }
            });

            List liste = students;
            liste.sort((a, b) {
              if (b[lecture][which] == null && a[lecture][which] == null)
                return 0;
              if (b[lecture][which] == null && a[lecture][which] != null)
                return -1;
              if (b[lecture][which] != null && a[lecture][which] == null)
                return 1;
              return b[lecture][which].compareTo(a[lecture][which]);
            });

            liste = liste
                .where((element) =>
                    element[lecture][which] == liste[0][lecture][which])
                .map((e) => {
                      "displayName": e["displayName"],
                      "uid": e.id,
                      "grade": e[lecture][which],
                    })
                .toList();

            CollectionReference ref = FirebaseFirestore.instance
                .collection("examDetails/$fullClass/$lecture");
            if (branchCount != 0 && gradeCount != 0)
              await ref.doc("$which").set({
                "branchMean": branchSum / branchCount,
                "gradeMean": gradeSum / gradeCount,
                "mostSuccessful": liste,
              });
          });
      });
    });
    print("bitti");
  }
}
