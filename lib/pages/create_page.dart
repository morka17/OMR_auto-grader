import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_provider.dart';

class CreatePage extends StatefulWidget {
  static const String id = "/create_record";
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final GlobalKey<FormState> _formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formstate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null) {
                      return "*required";
                    }
                    return value.isEmpty ? "*required" : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Course Title",
                    hintText: "CSC110",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Type here",
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(height: 34),
                Text(
                  "Questions Length",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        context.read<CreateProvider>().increQuestionsLength();
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 33,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: const Color.fromARGB(255, 228, 228, 228),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                          context
                              .watch<CreateProvider>()
                              .questionsLength
                              .toString(),
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        context.read<CreateProvider>().decreQuestionsLength();
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Text(
                  "Option type ?",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "YES",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Checkbox(
                          value: context.watch<CreateProvider>().isOptionType,
                          onChanged: (value) {
                            context.read<CreateProvider>().changeOptionType();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Row(
                      children: [
                        const Text(
                          "NO",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Checkbox(
                          value: !context.watch<CreateProvider>().isOptionType,
                          onChanged: (value) {
                            context.read<CreateProvider>().changeOptionType();
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formstate.currentState!.validate()) {
            Navigator.pushNamed(context, "/options");
          }
        },
        child: const Icon(
          Icons.arrow_forward,
        ),
      ),
    );
  }
}
