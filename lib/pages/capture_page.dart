import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:image_processing_contouring/Classes/Contour.dart';
import 'package:image_processing_contouring/Image/ImageContouring.dart';
import 'package:image_processing_contouring/Image/ImageDrawing.dart';
import 'package:image_processing_contouring/Image/ImageManipulation.dart';
import 'package:image_processing_contouring/Image/ImageOperation.dart';
import 'package:provider/provider.dart';

import '../providers/capture_provider.dart';
import '../utils/image_spilter.dart';

class CaptureScreen extends StatefulWidget {
  static const String id = "/capture";
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  @override
  void initState() {
    super.initState();
    // context.read<Capture>().box = drawContours()?.getWidget(BoxFit.contain);
    // var biggestContour = drawBiggestContours();
    // context.read<Capture>().biggestBox =
    //     biggestContour?.getWidget(BoxFit.contain);

    // setState(() {});
  }
  // im.Image blankImage = im.decodeImage()

  //  Image? blankImage = Image.asset("images/blank_image.png");

  // Apply a threshold and detect contours
  List<Contour>? getContours() {
    return context.read<Capture>().ima?.threshold(100).detectContours();
  }

  // Future<im.Image?> pickImage() async {
  //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (file?.path != null) {
  //     ima = LoadImageFromPath(file!.path);
  //     return ima;
  //   }
  //   print("Image is null");
  //   return null;
  // }

  // Draw all the contours on the image in red
  im.Image? drawContours() {
    var contours =
        getContours()?.where((contour) => contour.getArea() > 90).toList();
    return context.read<Capture>().ima?.drawContours(
        contours!, im.ColorFloat16.rgb(255, 0, 0),
        filled: false);
  }

  // Sort all the contours on the image in red
  void sortContours(List<Contour>? contours) {
    return contours?.sort((c, b) => (b.getArea() - c.getArea()).toInt());
  }

  // Draw the biggest contour in green and filled
  im.Image? drawBiggestContours() {
    var contours = getContours();

    // im.Image.fromBytes(bytes: , width: 200, height: 400 );
    sortContours(contours);
    Contour biggestContour = contours!.first;

    // double area = biggestContour.getArea();
    // var point = biggestContour.Points;
    // double perimeter = biggestContour.getPerimeter();

    context.read<Capture>().blackImage = im.copyCrop(
        context.read<Capture>().ima!,
        x: 110,
        y: 0,
        width: context.read<Capture>().ima!.width - 110,
        height: context.read<Capture>().ima!.height - 80);

    context.read<Capture>().blackImage?.getBytes();

    return context
        .read<Capture>()
        .ima
        ?.drawContour(biggestContour, im.ColorFloat16.rgb(0, 255, 0), false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sheet segmentation"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Biggest contours",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    // if (context.read<Capture>().biggestBox?.toUint8List() ==
                    //     null) {
                    //   return Container();
                    // }
                    return Container(
                      child: context
                          .watch<Capture>()
                          .biggestBox!
                          .getWidget(BoxFit.fill),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Graysale Image",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  child: Builder(builder: (context) {
                    if (context.read<Capture>().blackImage == null) {
                      return Container();
                    }
                    return im
                        .grayscale(context.read<Capture>().blackImage!.clone())
                        .getWidget(BoxFit.fill);
                  }),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Options segmentation",
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 10),

                Builder(builder: (context) {
                  if (context.watch<Capture>().blackImage == null)
                    return Container();
                  // Horizontal images
                  im.Image biggestImage = im
                      .grayscale(context.watch<Capture>().blackImage!.clone());
                  var hSplitedImages = horizontalSplit(biggestImage, 5);
                  // print("LENGTH ${splitedImages.length}");

                  List<Widget> hParts = [];
                  List<Widget> vParts = [];

                  // print("Horizontal split ${hSplitedImages.length}");
                  // List<int> shadedIndex = [];
                  

                  for (final hImage in hSplitedImages) {
                    // print("Hello world ${value++}");
                    final vSplittedImages = verticalSplit(hImage, 5, 5);
                    context.read<Capture>().getOptionBoxes(vSplittedImages);
                    // print(context.watch<Capture>().optionsBoxes);

                    // print("Iteration ${index++}");
                    // print(vSplittedImages);
                    for (final vImage in vSplittedImages) {
                      vParts.add(
                        Container(
                          color: Colors.black,
                          padding: const EdgeInsets.only(
                            left: 2.0,
                            bottom: 2,
                            right: 2,
                          ),
                          child: Image.memory(im.encodeJpg(vImage)),
                        ),
                      );
                    }
                    hParts.add(Container(
                      // padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: vParts,
                      ),
                    ));
                    vParts = [];
                  }

                  return Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: hParts,
                      ),
                      // for (var shaded in shadedIndex) Text(shaded.toString())
                    ],
                  );
                }),
                const SizedBox(height: 30),
                // ElevatedButton(
                //   onPressed: () async {
                //     for (var options in OptionsRow) {
                //       var index = await getShadedArea(options);
                //       print(index);
                //     }
                //   },
                //   child: const Text("Result"),
                // ),
                // for (final image in splitedImages) Container(child: image)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<Capture>().findAnswer(context);
          // await pickImage();
          // box = drawContours()?.getWidget(BoxFit.contain);
          // var biggestContour = drawBiggestContours();
          // biggestBox = biggestContour?.getWidget(BoxFit.contain);

          // setState(() {});
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
