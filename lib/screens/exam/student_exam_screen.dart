import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentExamScreen extends StatefulWidget {
  static const url = "/student-exam";

  @override
  _StudentExamScreenState createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
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
        columnName: 'firstExam',
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
        columnName: 'secondExam',
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
        columnName: 'thirdExam',
        label: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            '3. Sınav',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // columnWidthMode: ColumnWidthMode.lastColumnFill,
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
        // columnWidthMode: ColumnWidthMode.lastColumnFill,
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
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    title: Text("Sınıf ort"),
                    trailing: Text("Benim notum 53"),
                    subtitle: Text("90"),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.done,
                      color: Colors.red,
                    ),
                    title: Text("Okul ort"),
                    trailing: Text("Benim notum 60"),
                    subtitle: Text("80"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
                      ),
                    ),
                    title: Text("En başarılı"),
                    trailing: Text("Hacı Mehmet"),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://firebasestorage.googleapis.com/v0/b/school-f162e.appspot.com/o/default.jpg?alt=media&token=98ab15cf-2ea9-43db-a725-970650e5df5f",
                      ),
                    ),
                    title: Text("Başarısını en çok arttıran"),
                    trailing: Text("Mükerrem"),
                  ),
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
              .doc("07vrUvDetmXAOU1zzWq3JBCKcds2")
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

  // Overrides

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
      return Container(
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
