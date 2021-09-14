import 'package:flutter/material.dart';

class StudentCheckBox extends ChangeNotifier {
  bool _isChecked = false;

  get isChecked {
    return _isChecked;
  }

  void change() {
    _isChecked = !_isChecked;
    notifyListeners();
  }

  // Önceden alınmış yoklama varsa o yoklamayı tekrar gösterirken kullandık
  void setIsChecked(bool value) {
    _isChecked = value;
  }
}
