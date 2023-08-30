import 'package:flutter/material.dart';

class CreateCard extends StatelessWidget {
  final IconData iconData;
  final String textLabel;
  final void Function()? onTap;
  const CreateCard(
      {Key? key, required this.iconData, required this.textLabel, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            height: 160,
            width: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(59, 167, 166, 166),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1.0),
            ),
            child: Icon(
              iconData,
              color: const Color.fromARGB(255, 81, 80, 80),
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          textLabel,
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        )
      ],
    );
  }
}
