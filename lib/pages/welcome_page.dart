import 'package:flutter/material.dart';

import '../widgets/components.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = "/welcome";
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  CreateCard(
                    textLabel: "Create",
                    iconData: Icons.create_new_folder_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, "/create_record");
                    },
                  ),
                  const SizedBox(width: 20),
                  CreateCard(
                    textLabel: "Recent",
                    iconData: Icons.folder,
                    onTap: () {
                      Navigator.pushNamed(context, "/create_record");
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
