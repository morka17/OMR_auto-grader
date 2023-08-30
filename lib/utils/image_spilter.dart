import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;

import 'binarize_image.dart';

List<Image> splitImage(im.Image? data) {
  // Convert image to image from the image package
  im.Image? img = data;
  if (img == null) {
    return [];
  }

  // Getting image description
  int x = 0, y = 0;
  int width = (img.width / 3).round();
  int height = (img.height / 3).round();

  // Pixels

  // Split image to parts
  List<im.Image> parts = [];
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      im.Image part =
          im.copyCrop(img, x: x, y: y, width: width, height: height);
      parts.add(part);
      x += width;
    }
    x = 0;
    y += height;
  }

  // Convert image from image package to image widget to display
  List<Image> output = [];
  for (var ima in parts) {
    output.add(Image.memory(im.encodeJpg(ima)));
  }

  return output;
}

List<im.Image> verticalSplit(im.Image? data, int row, int col) {
  // Convert image to image from the image package
  im.Image? img = data;
  if (img == null) {
    return [];
  }

  // Getting image description
  int x = 0, y = 0;
  int width = (img.width / col).round();
  int height = (img.height).round();

  // Split image to parts
  List<im.Image> parts = [];
  for (int i = 0; i < row; i++) {
    var part = im.copyCrop(img, x: x, y: y, width: width, height: height);

    parts.add(part);
    // x
    x += width;
    // y += height;
  }
  return parts;
}

List<im.Image> horizontalSplit(im.Image? data, int row) {
  // Convert image to image from the image package
  im.Image? img = data;
  if (img == null) {
    return [];
  }

  // Getting image description
  int x = 0, y = 0;
  int width = (img.width).round();
  int height = (img.height / row).round();

  // Split image to parts
  List<im.Image> parts = [];
  for (int i = 0; i < row; i++) {
    var part = im.copyCrop(img, x: x, y: y, width: width, height: height);
    parts.add(part);
    // x
    y += height;
  }

  // Convert image from image package to image widget to display
  // List<Image> output = [];
  // for (var ima in parts) {
  //   output.add(Image.memory(im.encodeJpg(ima)));
  // }

  return parts;
}
