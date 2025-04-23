import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/produto.dart';

class ProdutoService {
  static const String _produtosKey = 'produtos';
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Produto>> getProdutos() async {
    await init();
    final String jsonString = _prefs.getString(_produtosKey) ?? '[]';
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) {
      return Produto(
        id: json['id'] as int,
        nome: json['nome'] as String,
        preco: (json['preco'] as num).toDouble(),
        quantidade: json['quantidade'] as int,
      );
    }).toList();
  }

  Future<void> adicionarProduto(Produto produto) async {
    await init();
    final produtos = await getProdutos();
    produtos.add(produto);
    await _salvarProdutos(produtos);
  }

  Future<void> atualizarProduto(Produto produto) async {
    await init();
    final produtos = await getProdutos();
    final index = produtos.indexWhere((p) => p.id == produto.id);
    if (index != -1) {
      produtos[index] = produto;
      await _salvarProdutos(produtos);
    }
  }

  Future<void> removerProduto(int id) async {
    await init();
    final produtos = await getProdutos();
    produtos.removeWhere((p) => p.id == id);
    await _salvarProdutos(produtos);
  }

  Future<void> _salvarProdutos(List<Produto> produtos) async {
    final List<Map<String, dynamic>> produtosMap = produtos.map((produto) => {
      'id': produto.id,
      'nome': produto.nome,
      'preco': produto.preco,
      'quantidade': produto.quantidade,
    }).toList();
    
    final String jsonString = jsonEncode(produtosMap);
    await _prefs.setString(_produtosKey, jsonString);
  }
} 