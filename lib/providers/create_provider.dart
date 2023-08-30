import 'package:flutter/material.dart';

class CreateProvider extends ChangeNotifier {
  bool _isOptionType = false;
  int _questionsLength = 0;

  int get questionsLength => _questionsLength;

  set questionsLength(value) {
    _questionsLength = value;
    notifyListeners();
  }

  void increQuestionsLength() {
    _questionsLength++;
    notifyListeners();
  }

  void decreQuestionsLength() {
    _questionsLength--;
    notifyListeners();
  }

  bool get isOptionType => _isOptionType;
  set isOptionType(value) {
    _isOptionType = value;
    notifyListeners();
  }

  void changeOptionType() {
    _isOptionType = !_isOptionType;
    notifyListeners();
  }
}
