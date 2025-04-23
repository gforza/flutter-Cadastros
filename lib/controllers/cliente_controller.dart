import '../models/cliente.dart';
import '../utils/storage.dart';

class ClienteController {
  Future<List<Cliente>> getClientes() async {
    final data = await Storage.readJsonFile('clientes.json');
    return data.map((json) => Cliente.fromJson(json)).toList();
  }

  Future<void> addCliente(Cliente cliente) async {
    final clientes = await getClientes();
    clientes.add(cliente);
    await Storage.writeJsonFile('clientes.json', clientes.map((c) => c.toJson()).toList());
  }

  Future<void> updateCliente(Cliente cliente) async {
    final clientes = await getClientes();
    final index = clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      clientes[index] = cliente;
      await Storage.writeJsonFile('clientes.json', clientes.map((c) => c.toJson()).toList());
    }
  }

  Future<void> deleteCliente(int id) async {
    final clientes = await getClientes();
    clientes.removeWhere((cliente) => cliente.id == id);
    await Storage.writeJsonFile('clientes.json', clientes.map((c) => c.toJson()).toList());
  }

  Future<Cliente?> getClienteById(int id) async {
    final clientes = await getClientes();
    try {
      return clientes.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
} 