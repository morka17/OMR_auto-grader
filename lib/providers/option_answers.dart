import 'package:flutter/material.dart';

abstract class PaperType extends ChangeNotifier {
  final List<List<int>> optionTypeAnswers = List.generate(
      50, (index) => List.filled(5, 0, growable: false),
      growable: true);

  void markAnswer(int row, int col);
}

// Paper type A block
class PaperTypeA extends ChangeNotifier implements PaperType {
  List<List<int>> _optionTypeAnswers = List.generate(
    50,
    (index) => List.filled(5, 0, growable: false),
    growable: true,
  );
  

  List<int> _answerIndex = List<int>.filled(100, 0, growable: true);

  // Getter
  @override
  List<List<int>> get optionTypeAnswers => _optionTypeAnswers;

  List<int> get answerIndex => _answerIndex;

  set answerIndex(value) {
    _answerIndex = value;
    notifyListeners();
  }

  // Settter
  set optionTypeAnsers(value) {
    _optionTypeAnswers = value;
    notifyListeners();
  }

  @override
  void markAnswer(int row, int col) {
    if (_optionTypeAnswers[row][col] == 1) {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 0;
    } else {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 1;
    }

    //  Answer index 
    _answerIndex[row]  = col;

    notifyListeners();
  }
}

// Paper type B block
class PaperTypeB extends ChangeNotifier implements PaperType {
  List<List<int>> _optionTypeAnswers = List.generate(
    50,
    (index) => List.filled(5, 0, growable: false),
    growable: true,
  );

  //  Getter
  @override
  List<List<int>> get optionTypeAnswers => _optionTypeAnswers;

  @override
  void markAnswer(int row, int col) {
    if (_optionTypeAnswers[row][col] == 1) {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 0;
    } else {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 1;
    }
    notifyListeners();
  }
}

// Paper type C block
class PaperTypeC extends ChangeNotifier implements PaperType {
  List<List<int>> _optionTypeAnswers = List.generate(
    50,
    (index) => List.filled(5, 0, growable: false),
    growable: true,
  );

  // Getter
  @override
  List<List<int>> get optionTypeAnswers => _optionTypeAnswers;

  // Settter
  set optionTypeAnsers(value) {
    _optionTypeAnswers = value;
    notifyListeners();
  }

  @override
  void markAnswer(int row, int col) {
    if (_optionTypeAnswers[row][col] == 1) {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 0;
    } else {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 1;
    }
    notifyListeners();
  }
}

// Paper type D block
class PaperTypeD extends ChangeNotifier implements PaperType {
  List<List<int>> _optionTypeAnswers = List.generate(
    50,
    (index) => List.filled(5, 0, growable: false),
    growable: true,
  );

  // Getter
  @override
  List<List<int>> get optionTypeAnswers => _optionTypeAnswers;

  // Settter
  set optionTypeAnsers(value) {
    _optionTypeAnswers = value;
    notifyListeners();
  }

  @override
  void markAnswer(int row, int col) {
    if (_optionTypeAnswers[row][col] == 1) {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 0;
    } else {
      _optionTypeAnswers[row] = List.filled(5, 0, growable: false);
      _optionTypeAnswers[row][col] = 1;
    }
    notifyListeners();
  }
}
