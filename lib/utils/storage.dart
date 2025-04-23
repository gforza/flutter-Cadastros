import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final initialized = prefs.getBool('initialized');
    if (initialized == null || !initialized) {
      await _criarDadosIniciais(prefs);
      await prefs.setBool('initialized', true);
    }
  }

  static Future<void> _criarDadosIniciais(SharedPreferences prefs) async {
    if (!prefs.containsKey('usuarios')) {
      await prefs.setString('usuarios', '[]');
    }
    if (!prefs.containsKey('clientes')) {
      await prefs.setString('clientes', '[]');
    }
    if (!prefs.containsKey('produtos')) {
      await prefs.setString('produtos', '[]');
    }
  }

  static Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(fileName) ?? '[]';
      return List<Map<String, dynamic>>.from(json.decode(data));
    } catch (e) {
      return [];
    }
  }

  static Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fileName, json.encode(data));
    } catch (e) {
      throw Exception('Erro ao salvar dados: $e');
    }
  }
} 