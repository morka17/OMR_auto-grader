import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;

import 'dart:io';

Future<int> countBlackPixels(im.Image img) async {
  int whitePixelCount = 0;

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      final pixel = img.getPixel(x, y);
      if (pixel.r == 255 && pixel.g == 255 && pixel.b == 255) {
        whitePixelCount++;
      }
    }
  }

  // print(whitePixelCount);

  return whitePixelCount;
}

Future<int> getShadedArea(List<im.Image?> options) async {
  Map<int, int> entries = {};
  
  int minCount = await countBlackPixels(options[0]!);
  entries[minCount] = 0;

  // int minIndex = 0;

  int len = options.length;
  // print("Options length ============================== $len");

  for (int i = 1; i < len; i++) {
    var count = await countBlackPixels(options[i]!);

    entries[count] = i;

    // print(count);
    if (minCount > count) {
      minCount = count;
      // minIndex++;
    }

    // minCount = count;
  }

  // print("minIndex $minIndex");
  // print("minCount $minCount ${entries[minCount]}");

  // print("============= End ===================");

  // for (var option in options) {
  //   var count = await countBlackPixels(option);
  //   if (count >= maxCount) {
  //     maxCount = count;
  //     maxIndex++;
  //   }
  // }
  // print(maxIndex);

  return Future.value(entries[minCount]);
}
