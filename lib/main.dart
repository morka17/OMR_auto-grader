import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_proc/pages/capture_page.dart';
import 'package:image_proc/pages/create_page.dart';
import 'package:image_proc/pages/option_answers_page.dart';
import 'package:image_proc/pages/record_screen.dart';
import 'package:image_proc/pages/welcome_page.dart';
import 'package:image_proc/providers/capture_provider.dart';
import 'package:image_proc/providers/create_provider.dart';
import 'package:image_proc/providers/record_provider.dart';
import 'package:image_proc/utils/binarize_image.dart';
import 'package:image_proc/utils/image_spilter.dart';
import 'package:image_processing_contouring/Classes/Contour.dart';
import 'package:image_processing_contouring/Image/ImageContouring.dart';
import 'package:image_processing_contouring/Image/ImageDrawing.dart';
import 'package:image_processing_contouring/Image/ImageManipulation.dart';
import 'package:image_processing_contouring/Image/ImageOperation.dart';
import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';

import 'providers/option_answers.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PaperTypeA()),
      ChangeNotifierProvider(create: (_) => CreateProvider()),
      ChangeNotifierProvider(create: (_) => RecordProvider()),
      ChangeNotifierProvider(create: (_) => Capture())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(),
      initialRoute: RecordScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        CreatePage.id: (context) => const CreatePage(),
        OptionsPage.id: (context) => const OptionsPage(),
        RecordScreen.id: (context) => const RecordScreen(),
        CaptureScreen.id: (context) => const CaptureScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // easily load image from path

  List<Image> splitedImages = [];
  im.Image? blackImage;
  Image? box;
  Image? biggestBox;
  im.Image? ima;

  // im.Image blankImage = im.decodeImage()

  //  Image? blankImage = Image.asset("images/blank_image.png");

  // Apply a threshold and detect contours
  List<Contour>? getContours() {
    return ima?.threshold(100).detectContours();
  }

  Future<im.Image?> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file?.path != null) {
      ima = LoadImageFromPath(file!.path);
      return ima;
    }
    print("Image is null");
    return null;
  }

  // Draw all the contours on the image in red
  im.Image? drawContours() {
    var contours =
        getContours()?.where((contour) => contour.getArea() > 90).toList();
    return ima?.drawContours(contours!, im.ColorFloat16.rgb(255, 0, 0),
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

    double area = biggestContour.getArea();
    var point = biggestContour.Points;
    double perimeter = biggestContour.getPerimeter();

    blackImage = im.copyCrop(ima!,
        x: 110, y: 0, width: ima!.width - 110, height: ima!.height - 80);

    blackImage?.getBytes();

    return ima?.drawContour(
        biggestContour, im.ColorFloat16.rgb(0, 255, 0), false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // var box = drawContours()?.getWidget(BoxFit.contain);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Biggest contours"),
                Builder(
                  builder: (context) {
                    return Container(
                      child: biggestBox,
                    );
                  },
                ),
                const Text("Blank Image"),
                Builder(
                  builder: (context) {
                    if (blackImage == null) {
                      return Container();
                    }
                    return Container(
                      child: Image.memory(im.encodePng(blackImage!)),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  child: Builder(builder: (context) {
                    if (blackImage == null) {
                      return Container();
                    }
                    return im
                        .grayscale(blackImage!.clone())
                        .getWidget(BoxFit.fill);
                  }),
                ),
                const SizedBox(height: 10),

                Builder(builder: (context) {
                  if (blackImage == null) return Container();
                  // Horizontal images
                  im.Image biggestImage = im.grayscale(blackImage!.clone());
                  var hSplitedImages = horizontalSplit(biggestImage, 5);
                  // print("LENGTH ${splitedImages.length}");

                  List<Widget> hParts = [];
                  List<Widget> vParts = [];
                  List<int> shadedIndex = [];

                  for (final hImage in hSplitedImages) {
                    final vSplittedImages = verticalSplit(hImage, 5, 5);

                    for (final vImage in vSplittedImages) {
                    
                      vParts.add(
                        Container(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Image.memory(im.encodeJpg(vImage)),
                        ),
                      );
                    }
                    hParts.add(Container(
                      padding: const EdgeInsets.only(bottom: 2),
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
                      for (var shaded in shadedIndex) Text(shaded.toString())
                    ],
                  );
                }),
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
          await pickImage();
          box = drawContours()?.getWidget(BoxFit.contain);
          var biggestContour = drawBiggestContours();
          biggestBox = biggestContour?.getWidget(BoxFit.contain);

          setState(() {});
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
