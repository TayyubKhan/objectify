// infrastructure/drawing_repository.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DrawingRepository {
  Future<void> saveDrawing(String id, List<Map<String, dynamic>> strokes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/drawing_$id.json');
    await file.writeAsString(jsonEncode({'id': id, 'strokes': strokes}));
  }

  Future<List<Map<String, dynamic>>?> loadDrawing(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/drawing_$id.json');
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      return List<Map<String, dynamic>>.from(data['strokes']);
    }
    return null;
  }
}
