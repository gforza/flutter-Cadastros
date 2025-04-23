import '../models/usuario.dart';
import '../utils/storage.dart';

class UsuarioController {
  Future<Usuario?> login(String username, String password) async {
    final usuarios = await getUsuarios();
    try {
      return usuarios.firstWhere(
        (usuario) => usuario.nome == username && usuario.senha == password,
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<Usuario>> getUsuarios() async {
    final data = await Storage.readJsonFile('usuarios.json');
    return data.map((json) => Usuario.fromJson(json)).toList();
  }

  Future<void> addUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    usuarios.add(usuario);
    await Storage.writeJsonFile('usuarios.json', usuarios.map((u) => u.toJson()).toList());
  }

  Future<void> updateUsuario(Usuario usuario) async {
    final usuarios = await getUsuarios();
    final index = usuarios.indexWhere((u) => u.id == usuario.id);
    if (index != -1) {
      usuarios[index] = usuario;
      await Storage.writeJsonFile('usuarios.json', usuarios.map((u) => u.toJson()).toList());
    }
  }

  Future<void> deleteUsuario(int id) async {
    final usuarios = await getUsuarios();
    usuarios.removeWhere((usuario) => usuario.id == id);
    await Storage.writeJsonFile('usuarios.json', usuarios.map((u) => u.toJson()).toList());
  }

  Future<Usuario?> getUsuarioById(int id) async {
    final usuarios = await getUsuarios();
    try {
      return usuarios.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }
} 