import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:image_proc/providers/option_answers.dart';
import 'package:image_proc/utils/binarize_image.dart';
import 'package:image_processing_contouring/Classes/Contour.dart';
import 'package:image_processing_contouring/Image/ImageContouring.dart';
import 'package:image_processing_contouring/Image/ImageDrawing.dart';
import 'package:image_processing_contouring/Image/ImageManipulation.dart';
import 'package:image_processing_contouring/Image/ImageOperation.dart';

import 'package:provider/provider.dart';

class Capture extends ChangeNotifier {
  int index = 0;
// OPTIONS ARRAY
  List<List<im.Image?>> _optionsBoxes =
      List<List<im.Image?>>.generate(5, (index) => List<im.Image>.empty());

  String _imagePath = "";
  im.Image? _blackImage;
  im.Image? _box;
  im.Image? _biggestBox;

  im.Image? _ima;

  // Getters
  im.Image? get blackImage => _blackImage;
  im.Image? get ima => _ima;
  im.Image? get box => _box;
  im.Image? get biggestBox => _biggestBox;
  List<List<im.Image?>> get optionsBoxes => _optionsBoxes;
  String get imagePath => _imagePath;

  // Settter
  set blackImage(value) {
    _blackImage = value;
    notifyListeners();
  }

  // set optionBoxes(value) {
  //   _optionsBoxes = value;
  //   notifyListeners();
  // }

  set box(value) {
    _box = value;
    notifyListeners();
  }

  set biggestBox(value) {
    _biggestBox = value;
    notifyListeners();
  }

  set ima(value) {
    _ima = value;
    notifyListeners();
  }

  void getOptionBoxes(List<im.Image> image) {
    _optionsBoxes.add(image);
    print("box ${_optionsBoxes.length}");
  }

  void reset() {
    index = 0;
    _optionsBoxes = [[]];
  }

  /// Capture the answer sheet
  Future<void> captureSheet(context) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file?.path == null) {
      return;
    }

    _ima = LoadImageFromPath(file!.path);
    _biggestBox = drawBiggestContours(context);
    _box = drawContours(context);
    _imagePath = file.path;

    reset();
  }

  // Apply a threshold and detect contours
  List<Contour>? getContours() {
    return _ima!.threshold(100).detectContours();
  }

  // Draw all the contours on the image in red
  im.Image? drawContours(context) {
    var contours =
        getContours()?.where((contour) => contour.getArea() > 90).toList();
    return _ima?.drawContours(contours!, im.ColorFloat16.rgb(255, 0, 0),
        filled: false);
  }

  // Sort all the contours on the image in red
  void sortContours(List<Contour>? contours) {
    return contours?.sort((c, b) => (b.getArea() - c.getArea()).toInt());
  }

  // Draw the biggest contour in green and filled
  im.Image? drawBiggestContours(context) {
    var contours = getContours();

    // im.Image.fromBytes(bytes: , width: 200, height: 400 );
    sortContours(contours);
    Contour biggestContour = contours!.first;

    // double area = biggestContour.getArea();
    // var point = biggestContour.Points;
    // double perimeter = biggestContour.getPerimeter();

    _blackImage = im.copyCrop(_ima!,
        x: 110, y: 0, width: _ima!.width - 110, height: _ima!.height - 80);

    // context.read<Capture>().blackImage?.getBytes();

    return _ima?.drawContour(
        biggestContour, im.ColorFloat16.rgb(0, 255, 0), false);
  }

  Future<void> findAnswer(BuildContext context) async {
    int correct = 0;

    print("boxes length ${_optionsBoxes.length}");
    for (int i = 0; i < _optionsBoxes.length; i++) {
      if (i == 0) continue;
      var row = _optionsBoxes[i];
      final shadedIndex = await getShadedArea(row);
      // print(shadedIndex);
      // ... Compare answer with the shaded option
      if (context.read<PaperTypeA>().answerIndex[--i] == shadedIndex) {
        correct += 1;
      }
    }

    print("Total correct anwsers is $correct");
  }
}
