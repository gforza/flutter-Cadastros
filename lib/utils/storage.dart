import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    try {
      final box = await Hive.openBox(fileName);
      final data = box.get('data', defaultValue: '[]');
      return List<Map<String, dynamic>>.from(json.decode(data));
    } catch (e) {
      return [];
    }
  }

  static Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    final box = await Hive.openBox(fileName);
    await box.put('data', json.encode(data));
  }
} 