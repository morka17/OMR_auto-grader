import 'package:editable/editable.dart';
import 'package:flutter/material.dart';
import 'package:image_proc/providers/capture_provider.dart';
import 'package:image_proc/providers/record_provider.dart';
import 'package:provider/provider.dart';

class RecordScreen extends StatefulWidget {
  static const String id = "/records";
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Records"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/options");
            },
            icon: const Icon(
              Icons.edit_note_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Editable(
        rows: context.watch<RecordProvider>().rows,
        columns: context.watch<RecordProvider>().cols,
        columnCount: context.watch<RecordProvider>().cols.length,
        rowCount: context.watch<RecordProvider>().rows.length,
        columnRatio: 0.6,
        zebraStripe: true,
        stripeColor2: Colors.grey.shade200,
        borderColor: Colors.blueGrey,
        // showSaveIcon: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.read<Capture>().captureSheet(context).then(
                (_) => Navigator.pushNamed(context, "/capture"),
              );
        },
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
