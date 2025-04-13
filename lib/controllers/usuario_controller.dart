import '../models/usuario.dart';
import '../utils/storage.dart';

class UsuarioController {
  static const String _fileName = 'usuarios';

  static Future<List<Usuario>> getUsuarios() async {
    final data = await Storage.readJsonFile(_fileName);
    return data.map((json) => Usuario.fromJson(json)).toList();
  }

  static Future<void> addUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    usuarios.add(usuario);
    await Storage.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
  }

  static Future<void> updateUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    final index = usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      usuarios[index] = usuario;
      await Storage.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
    }
  }

  static Future<void> deleteUsuario(int id) async {
    final usuarios = await getUsuarios();
    usuarios.removeWhere((u) => u.id == id);
    await Storage.writeJsonFile(_fileName, usuarios.map((u) => u.toJson()).toList());
  }

  static Future<Usuario?> getUsuarioById(int id) async {
    final usuarios = await getUsuarios();
    return usuarios.firstWhere((u) => u.id == id);
  }

  static Future<Usuario?> login(String nome, String senha) async {
    final usuarios = await getUsuarios();
    try {
      return usuarios.firstWhere((u) => u.nome == nome && u.senha == senha);
    } catch (e) {
      return null;
    }
  }
} 