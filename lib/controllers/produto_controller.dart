import '../models/produto.dart';
import '../utils/storage.dart';

class ProdutoController {
  Future<List<Produto>> getProdutos() async {
    final data = await Storage.readJsonFile('produtos.json');
    return data.map((json) => Produto.fromJson(json)).toList();
  }

  Future<void> addProduto(Produto produto) async {
    final produtos = await getProdutos();
    produtos.add(produto);
    await Storage.writeJsonFile('produtos.json', produtos.map((p) => p.toJson()).toList());
  }

  Future<void> updateProduto(Produto produto) async {
    final produtos = await getProdutos();
    final index = produtos.indexWhere((p) => p.id == produto.id);
    if (index != -1) {
      produtos[index] = produto;
      await Storage.writeJsonFile('produtos.json', produtos.map((p) => p.toJson()).toList());
    }
  }

  Future<void> deleteProduto(int id) async {
    final produtos = await getProdutos();
    produtos.removeWhere((produto) => produto.id == id);
    await Storage.writeJsonFile('produtos.json', produtos.map((p) => p.toJson()).toList());
  }

  Future<Produto?> getProdutoById(int id) async {
    final produtos = await getProdutos();
    try {
      return produtos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
} 