import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import '../models/record.dart' as rcd;

class RecordProvider extends ChangeNotifier {
  // Key for EditableState
  final GlobalKey<EditableState> _editableKey = GlobalKey<EditableState>();

  List<Map<String, dynamic>> _rows = [
    {
      "date": '23/09/2020',
      "matno": 'PSC1808876',
      "correct": '3',
      "bad": '2',
      "grade": "B"
    },
    // {
    //   "date": '12/4/2020',
    //   "month": 'March',
    //   "name": 'Daniel Paul',
    //   "status": 'new'
    // }
  ];

  final List<Map<String, dynamic>> _cols = [
    {"title": 'Date', 'widthFactor': 0.3, 'key': 'date'},
    {"title": 'matno', 'widthFactor': 0.3, 'key': 'matno'},
    {"title": 'correct', 'widthFactor': 0.3, 'key': 'correct'},
    {"title": 'bad', 'widthFactor': 0.3, 'key': 'bad'},
    {"title": 'Status', 'key': 'status', "widthFactor": 0.3},
  ];

  // Getters
  List<Map<String, dynamic>> get rows => _rows;
  List<Map<String, dynamic>> get cols => _cols;

  // set rows(rcd.Record value) {
  //   _rows.add(value.toMap());
  //   notifyListeners();
  // }

  GlobalKey<EditableState> get editableKey => _editableKey;

  void addNewRow(rcd.Record record) {
    _rows.add(record.toMap());
    _editableKey.currentState?.createRow();
    notifyListeners();
  }
}
