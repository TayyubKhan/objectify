import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TextFileScreen extends StatelessWidget {

  const TextFileScreen({super.key});

  Future<String> _fetchTextFileContent() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = join(appDocDir.path, 'example.txt'); // Example file path

    File file = File(filePath);
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return 'Text file not found';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text File Content'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<String>(
        future: _fetchTextFileContent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(snapshot.data ?? 'No content'),
            );
          }
        },
      ),
    );
  }
}

