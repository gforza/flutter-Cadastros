import '../models/cliente.dart';
import '../utils/storage.dart';

class ClienteController {
  static const String _fileName = 'clientes';

  static Future<List<Cliente>> getClientes() async {
    final data = await Storage.readJsonFile(_fileName);
    return data.map((json) => Cliente.fromJson(json)).toList();
  }

  static Future<void> addCliente(Cliente cliente) async {
    final clientes = await getClientes();
    clientes.add(cliente);
    await Storage.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
  }

  static Future<void> updateCliente(Cliente cliente) async {
    final clientes = await getClientes();
    final index = clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      clientes[index] = cliente;
      await Storage.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
    }
  }

  static Future<void> deleteCliente(int id) async {
    final clientes = await getClientes();
    clientes.removeWhere((c) => c.id == id);
    await Storage.writeJsonFile(_fileName, clientes.map((c) => c.toJson()).toList());
  }

  static Future<Cliente?> getClienteById(int id) async {
    final clientes = await getClientes();
    try {
      return clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
} 