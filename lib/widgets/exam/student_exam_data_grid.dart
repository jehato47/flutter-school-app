import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../helpers/datagrid/sinav_data_grid_source.dart';
// import 'package:syncfusion_flutter_core/theme.dart';

class StudentExamDataGrid extends StatefulWidget {
  final SinavDataGridSource _sinavDataGridSource;
  StudentExamDataGrid(this._sinavDataGridSource);

  @override
  _StudentExamDataGridState createState() => _StudentExamDataGridState();
}

class _StudentExamDataGridState extends State<StudentExamDataGrid> {
  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      selectionMode: SelectionMode.single,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      source: widget._sinavDataGridSource,
      columnWidthMode: ColumnWidthMode.fill,
      rowHeight: 50,
      columns: <GridColumn>[
        GridTextColumn(
            mappingName: 'sınav',
            columnWidthMode: ColumnWidthMode.cells,
            headerText: 'Sınav',
            headerTextAlignment: Alignment.centerLeft),
        GridNumericColumn(
            mappingName: 'first',
            headerText: '1.',
            padding: const EdgeInsets.all(8),
            headerTextAlignment: Alignment.center,
            textAlignment: Alignment.center),
        GridNumericColumn(
            mappingName: 'second',
            headerText: '2.',
            padding: const EdgeInsets.all(8),
            textAlignment: Alignment.center,
            headerTextAlignment: Alignment.center,
            columnWidthMode: ColumnWidthMode.auto),
        GridNumericColumn(
            mappingName: 'third',
            headerText: '3.',
            padding: const EdgeInsets.all(8),
            textAlignment: Alignment.center,
            headerTextAlignment: Alignment.center,
            columnWidthMode: ColumnWidthMode.auto),
        GridNumericColumn(
            mappingName: 'ort',
            padding: const EdgeInsets.all(8),
            textAlignment: Alignment.center,
            headerTextAlignment: Alignment.center,
            headerText: 'Ortalama'),
      ],
    );
  }
}
