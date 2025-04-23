import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class CadastroProdutoScreen extends StatefulWidget {
  final Produto? produto;

  const CadastroProdutoScreen({Key? key, this.produto}) : super(key: key);

  @override
  _CadastroProdutoScreenState createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _precoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _produtoService = ProdutoService();
  Produto? _produtoEmEdicao;
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
    if (widget.produto != null) {
      _produtoEmEdicao = widget.produto;
      _nomeController.text = _produtoEmEdicao!.nome;
      _precoController.text = _produtoEmEdicao!.preco.toString();
      _quantidadeController.text = _produtoEmEdicao!.quantidade.toString();
    }
  }

  Future<void> _carregarProdutos() async {
    final produtos = await _produtoService.getProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  void _limparCampos() {
    setState(() {
      _produtoEmEdicao = null;
      _nomeController.clear();
      _precoController.clear();
      _quantidadeController.clear();
    });
  }

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      try {
        final nome = _nomeController.text;
        final preco = double.parse(_precoController.text);
        final quantidade = int.parse(_quantidadeController.text);

        if (_produtoEmEdicao != null) {
          final produtoAtualizado = Produto(
            id: _produtoEmEdicao!.id,
            nome: nome,
            preco: preco,
            quantidade: quantidade,
          );
          await _produtoService.atualizarProduto(produtoAtualizado);
        } else {
          final novoProduto = Produto(
            id: DateTime.now().millisecondsSinceEpoch,
            nome: nome,
            preco: preco,
            quantidade: quantidade,
          );
          await _produtoService.adicionarProduto(novoProduto);
        }

        await _carregarProdutos();
        _limparCampos();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_produtoEmEdicao != null 
                ? 'Produto atualizado com sucesso!' 
                : 'Produto cadastrado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar produto: $e')),
          );
        }
      }
    }
  }

  Future<void> _excluirProduto(int id) async {
    await _produtoService.removerProduto(id);
    await _carregarProdutos();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produto excluído com sucesso'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _editarProduto(Produto produto) {
    setState(() {
      _produtoEmEdicao = produto;
      _nomeController.text = produto.nome;
      _precoController.text = produto.preco.toString();
      _quantidadeController.text = produto.quantidade.toString();
    });
  }

  void _visualizarProduto(Produto produto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Produto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${produto.nome}'),
            Text('Preço: R\$ ${produto.preco.toStringAsFixed(2)}'),
            Text('Quantidade: ${produto.quantidade}'),
            Text('ID: ${produto.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_produtoEmEdicao != null ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço *',
                      border: OutlineInputBorder(),
                      prefixText: 'R\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o preço do produto';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Por favor, insira um preço válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _quantidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a quantidade';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, insira uma quantidade válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _salvarProduto,
                        child: Text(_produtoEmEdicao != null ? 'Salvar Alterações' : 'Cadastrar Produto'),
                      ),
                      if (_produtoEmEdicao != null)
                        ElevatedButton(
                          onPressed: _limparCampos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text('Cancelar'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Produtos Cadastrados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  final produto = _produtos[index];
                  return ListTile(
                    title: Text(produto.nome),
                    subtitle: Text('R\$ ${produto.preco.toStringAsFixed(2)} - Qtd: ${produto.quantidade}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _visualizarProduto(produto),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editarProduto(produto),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluirProduto(produto.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 