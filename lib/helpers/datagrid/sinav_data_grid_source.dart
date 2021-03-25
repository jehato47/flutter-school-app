import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/sinav.dart';

class SinavDataGridSource extends DataGridSource<Sinav> {
  SinavDataGridSource(this.dataSource);
  final List<Sinav> dataSource;

  @override
  Object getValue(Sinav _sinav, String columnName) {
    switch (columnName) {
      case "sınav":
        print(_sinav.name);
        if (_sinav.name == "türk_dili") return "türk dili";
        if (_sinav.name == "cografya") return "coğrafya";
        return _sinav.name;
        break;
      case "first":
        return _sinav.first;
        break;
      case 'second':
        return _sinav.second;
        break;
      case 'third':
        return _sinav.third;
        break;
      case 'ort':
        return ((_sinav.first + _sinav.second + _sinav.third) / 3)
            .toStringAsFixed(2);
        break;
      default:
        return '';
        break;
    }
  }
}
