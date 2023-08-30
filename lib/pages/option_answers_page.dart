import 'package:flutter/material.dart';
import 'package:image_proc/providers/create_provider.dart';
import 'package:provider/provider.dart';

import '../providers/option_answers.dart';

class OptionsPage extends StatefulWidget {
  static const String id = "/options";
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  // static List<String> optionsType = const ["A", "B", "C", "D"];
  static List<String> options = const ["A", "B", "C", "D", "E"];

  String currentPaperType = "A";

  Widget sheet = QuestionsOption<PaperTypeA>(
    options: options,
  );

  void changePaperType(String option) {
    switch (option) {
      case "A":
        sheet = QuestionsOption<PaperTypeA>(
          options: options,
        );
        break;
      case "B":
        sheet = QuestionsOption<PaperTypeB>(
          options: options,
        );
        break;
      case "C":
        sheet = QuestionsOption<PaperTypeC>(
          options: options,
        );
        break;
      case "D":
        sheet = QuestionsOption<PaperTypeD>(
          options: options,
        );
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Container(
                //   alignment: Alignment.center,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       for (final option in optionsType)
                //         Row(
                //           children: [
                //             InkWell(
                //               onTap: () {
                //                 changePaperType(option);
                //                 currentPaperType = option;
                //                 setState(() {});
                //               },
                //               child: CircleAvatar(
                //                 backgroundColor: currentPaperType == option
                //                     ? Colors.green
                //                     : Colors.grey.shade300,
                //                 radius: currentPaperType == option ? 19 : 16,
                //                 child: Center(
                //                   child: Text(
                //                     option,
                //                     style: TextStyle(
                //                       color: currentPaperType == option
                //                           ? Colors.white
                //                           : Colors.black54,
                //                       fontSize: 18,
                //                       fontWeight: FontWeight.w600,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //             ),
                //             option != "D"
                //                 ? Container(
                //                     color: Colors.grey.shade400,
                //                     height: 5,
                //                     width: 50,
                //                   )
                //                 : Container(),
                //           ],
                //         )
                //     ],
                //   ),
                // ),
                const SizedBox(height: 15),
                Text(
                  "Paper type $currentPaperType",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                // width: size.width,
                // height: size.height,
                const SizedBox(height: 15),
                sheet,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/records");
        },
        child: const Icon(Icons.arrow_forward),
      ),
      // floatingActionButton: Container(
      //   padding: const EdgeInsets.symmetric(horizontal: 20),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       optionsType.indexOf(currentPaperType) <= 0
      //           ? Container()
      //           : FloatingActionButton(
      //               onPressed: () {
      //                 int currentIndex = optionsType.indexOf(currentPaperType);
      //                 print(currentIndex % 3);
      //                 if (currentIndex <= optionsType.length &&
      //                     currentIndex != 0) {
      //                   currentPaperType = optionsType[currentIndex - 1];
      //                   changePaperType(currentPaperType);
      //                   setState(() {});
      //                 }
      //               },
      //               child: const Icon(Icons.arrow_back),
      //             ),
      //       optionsType.indexOf(currentPaperType) == 3
      //           ? FloatingActionButton(
      //               backgroundColor: Colors.green,
      //               onPressed: () {
      //                 Navigator.pushNamed(context, "/records");
      //               },
      //               child: const Icon(Icons.check),
      //             )
      //           : FloatingActionButton(
      //               onPressed: () {
      //                 int currentIndex = optionsType.indexOf(currentPaperType);
      //                 print(currentIndex % 3);
      //                 if (currentIndex % optionsType.length <
      //                     optionsType.length - 1) {
      //                   currentPaperType = optionsType[currentIndex + 1];
      //                   changePaperType(currentPaperType);
      //                   setState(() {});
      //                 }
      //               },
      //               child: const Icon(Icons.arrow_forward),
      //             ),
      //     ],
      //   ),
      // ),
    );
  }
}

class QuestionsOption<T extends PaperType> extends StatelessWidget {
  const QuestionsOption({
    super.key,
    required this.options,
  });
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(builder: (context) {
      var paper = context.watch<T>();
      // print(paper.optionTypeA.length);
      return SizedBox(
        width: size.width,
        height: size.height - 130,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int question = 0;
                  question < context.read<CreateProvider>().questionsLength;
                  question++)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Text(
                        "${question + 1}.",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(
                        width: question < 9 ? 23 : 15,
                      ),
                      for (var option = 0; option < options.length; option++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              context.read<T>().markAnswer(question, option);

                              // setState(() {});
                            },
                            child: Container(
                              height: 23,
                              width: 23,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: paper.optionTypeAnswers[question]
                                            [option] ==
                                        1
                                    ? Colors.green
                                    : Colors.white60,
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Text(
                                options[option],
                                style: TextStyle(
                                  color: paper.optionTypeAnswers[question]
                                              [option] ==
                                          1
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
