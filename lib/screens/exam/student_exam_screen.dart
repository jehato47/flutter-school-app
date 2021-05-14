import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StudentExamScreen extends StatefulWidget {
  static const url = "/student-exam";

  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  dynamic examScore;
  Map exam3 = {
    "1": "matematik",
    "2": "fizik",
    "3": "kimya",
    "4": "biyoloji",
    "5": "türkçe",
    "6": "sosyalbilgiler",
    "7": "coğrafya",
    "8": "dilbilgisi",
  };
  List<GridColumn> getColumns() {
    List<GridColumn> columns;

    columns = <GridColumn>[
      GridTextColumn(
        columnName: 'lecture',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Sınav',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridTextColumn(
        columnName: '1',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            '1. Sınav',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridTextColumn(
        columnName: '2',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            '2. Sınav',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridTextColumn(
        columnName: '3',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            '3. Sınav',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridTextColumn(
        columnName: 'mean',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Ortalama',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
    return columns;
  }

  SfDataGrid _buildDataGrid(dynamic data) {
    return SfDataGrid(
      columnWidthMode: ColumnWidthMode.fill,

      source: _SelectionDataGridSource(data),
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      allowMultiColumnSorting: true,
      selectionMode: SelectionMode.single,
      navigationMode: GridNavigationMode.row,
      onCellDoubleTap: (details) async {
        // print(details.rowColumnIndex.columnIndex);
        dynamic indexes = details.rowColumnIndex;
        if (indexes.rowIndex == 0 ||
            indexes.columnIndex == 4 ||
            indexes.columnIndex == 0) return;

        String lecture = exam3[details.rowColumnIndex.rowIndex.toString()];
        // print(details.rowColumnIndex.columnIndex);
        // print(lecture);
        examScore = data[lecture][details.column.columnName];
        if (examScore == null) return;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection("examDetails/11-c/$lecture")
            .doc(details.rowColumnIndex.columnIndex.toString())
            .get();

        if (snapshot.data() == null) return;

        await showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (context) => BottomSheet(
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            onClosing: () {},
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    title: Text("Sınıf ort"),
                    subtitle: Text(snapshot["branchMean"].toStringAsFixed(2)),
                    trailing: Text("Benim notum $examScore"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: Colors.red,
                    ),
                    title: Text("Okul ort"),
                    subtitle: Text(snapshot["gradeMean"].toStringAsFixed(2)),
                    trailing: Text("Benim notum $examScore"),
                  ),
                  Divider(thickness: 1),
                  Center(
                    // padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "En başarılı öğrenciler",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ...snapshot["mostSuccessful"]
                      .map((e) => ListTile(
                            leading: Icon(
                              Icons.done,
                              color: Colors.blue,
                            ),
                            title: Text(e["displayName"]),
                            trailing: Text("Aldığı Not : ${e["grade"]}"),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),
        );
      },
      // controller: getDataGridController(),
      columns: getColumns(),
    );
  }

  SelectionMode selectionMode = SelectionMode.multiple;
  GridNavigationMode navigationMode = GridNavigationMode.cell;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenci Sonuç"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("exam")
              .doc("ECkPBIzt7xU0NDGuJa6T1KBRJTr1")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            return _buildDataGrid(snapshot.data);
          }),
    );
  }
}

class _SelectionDataGridSource extends DataGridSource {
  dynamic data;
  _SelectionDataGridSource(this.data) {
    exams = getExams();
    buildDataGridRows();
  }

  // final bool isWebOrDesktop;
  List<DataGridRow> dataGridRows = [];
  List<_Exam> exams = [];

  // Building DataGridRows

  void buildDataGridRows() {
    dataGridRows = exams.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'lecture', value: dataGridRow.lecture),
        DataGridCell(columnName: 'firstExam', value: dataGridRow.firstExam),
        DataGridCell(columnName: 'secondExam', value: dataGridRow.secondExam),
        DataGridCell(columnName: 'thirdExam', value: dataGridRow.thirdExam),
        DataGridCell(columnName: 'mean', value: dataGridRow.calculateMean()),
      ]);
    }).toList(growable: false);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    Widget buildWidget({
      AlignmentGeometry alignment = Alignment.center,
      EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
      TextOverflow textOverflow = TextOverflow.ellipsis,
      Object value,
    }) {
      return value == 100
          ? Image(
              // fit: BoxFit.cover,
              image: NetworkImage(
                "https://media.giphy.com/media/TgGWZwWlsODxFPA21A/giphy.gif",
              ),
            )
          : Container(
              padding: padding,
              alignment: alignment,
              child: Text(
                value == null ? "-" : value.toString(),
                overflow: textOverflow,
              ),
            );
    }

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
      // if (dataCell.columnName == 'lecture'
      // ||
      // dataCell.columnName == 'firstExam') {
      // return buildWidget(alignment: Alignment.center, value: dataCell.value);
      // } else {

      return buildWidget(value: dataCell.value);
      // }
    }).toList(growable: false));
  }

  List<_Exam> getExams() {
    final List<_Exam> examData = <_Exam>[
      _Exam(
        "Matematik",
        data["matematik"]["1"],
        data["matematik"]["2"],
        data["matematik"]["3"],
      ),
      _Exam(
        "Fizik",
        data["fizik"]["1"],
        data["fizik"]["2"],
        data["fizik"]["3"],
      ),
      _Exam(
        "Kimya",
        data["kimya"]["1"],
        data["kimya"]["2"],
        data["kimya"]["3"],
      ),
      _Exam(
        "Biyoloji",
        data["biyoloji"]["1"],
        data["biyoloji"]["2"],
        data["biyoloji"]["3"],
      ),
      _Exam(
        "Türkçe",
        data["türkçe"]["1"],
        data["türkçe"]["2"],
        data["türkçe"]["3"],
      ),
      _Exam(
        "Sosyal B.",
        data["sosyalbilgiler"]["1"],
        data["sosyalbilgiler"]["2"],
        data["sosyalbilgiler"]["3"],
      ),
      _Exam(
        "Coğrafya",
        data["coğrafya"]["1"],
        data["coğrafya"]["2"],
        data["coğrafya"]["3"],
      ),
      _Exam(
        "Dil B.",
        data["dilbilgisi"]["1"],
        data["dilbilgisi"]["2"],
        data["dilbilgisi"]["3"],
      ),
    ];

    return examData;
  }
}

class _Exam {
  _Exam(
    this.lecture,
    this.firstExam,
    this.secondExam,
    this.thirdExam,
  );
  dynamic calculateMean() {
    dynamic sum = 0;
    int count = 0;
    if (firstExam != null) {
      sum += firstExam;
      count += 1;
    }
    if (secondExam != null) {
      sum += secondExam;
      count += 1;
    }
    if (thirdExam != null) {
      sum += thirdExam;
      count += 1;
    }
    return count != 0 ? (sum / count).toStringAsFixed(2) : "-";
  }

  String lecture;
  dynamic firstExam;
  dynamic secondExam;
  dynamic thirdExam;
}
