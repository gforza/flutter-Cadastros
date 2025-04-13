import '../models/produto.dart';
import '../utils/storage.dart';

class ProdutoController {
  static const String _fileName = 'produtos';

  static Future<List<Produto>> getProdutos() async {
    final data = await Storage.readJsonFile(_fileName);
    return data.map((json) => Produto.fromJson(json)).toList();
  }

  static Future<void> addProduto(Produto produto) async {
    final produtos = await getProdutos();
    produtos.add(produto);
    await Storage.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
  }

  static Future<void> updateProduto(Produto produto) async {
    final produtos = await getProdutos();
    final index = produtos.indexWhere((p) => p.id == produto.id);
    if (index != -1) {
      produtos[index] = produto;
      await Storage.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
    }
  }

  static Future<void> deleteProduto(int id) async {
    final produtos = await getProdutos();
    produtos.removeWhere((p) => p.id == id);
    await Storage.writeJsonFile(_fileName, produtos.map((p) => p.toJson()).toList());
  }

  static Future<Produto?> getProdutoById(int id) async {
    final produtos = await getProdutos();
    try {
      return produtos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
} 