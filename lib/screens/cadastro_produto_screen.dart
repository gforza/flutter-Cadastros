import 'package:flutter/material.dart';
import '../controllers/produto_controller.dart';
import '../models/produto.dart';
import 'home_screen.dart';

class CadastroProdutoScreen extends StatefulWidget {
  const CadastroProdutoScreen({super.key});

  @override
  State<CadastroProdutoScreen> createState() => _CadastroProdutoScreenState();
}

class _CadastroProdutoScreenState extends State<CadastroProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _custoController = TextEditingController();
  final _codigoBarraController = TextEditingController();
  String _unidadeSelecionada = 'un';
  int _statusSelecionado = 0;
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    final produtos = await ProdutoController.getProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  Future<void> _salvarProduto() async {
    if (_formKey.currentState!.validate()) {
      final novoId = _produtos.isEmpty ? 1 : _produtos.last.id + 1;
      final produto = Produto(
        id: novoId,
        nome: _nomeController.text,
        unidade: _unidadeSelecionada,
        quantidadeEstoque: double.parse(_quantidadeController.text),
        precoVenda: double.parse(_precoVendaController.text),
        status: _statusSelecionado,
        custo: _custoController.text.isEmpty ? null : double.parse(_custoController.text),
        codigoBarra: _codigoBarraController.text.isEmpty ? null : _codigoBarraController.text,
      );

      await ProdutoController.addProduto(produto);
      await _carregarProdutos();

      _limparCampos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto cadastrado com sucesso')),
      );
    }
  }

  void _limparCampos() {
    _nomeController.clear();
    _quantidadeController.clear();
    _precoVendaController.clear();
    _custoController.clear();
    _codigoBarraController.clear();
    setState(() {
      _unidadeSelecionada = 'un';
      _statusSelecionado = 0;
    });
  }

  Future<void> _excluirProduto(int id) async {
    await ProdutoController.deleteProduto(id);
    await _carregarProdutos();
  }

  Future<void> _editarProduto(Produto produto) async {
    _nomeController.text = produto.nome;
    _unidadeSelecionada = produto.unidade;
    _quantidadeController.text = produto.quantidadeEstoque.toString();
    _precoVendaController.text = produto.precoVenda.toString();
    _statusSelecionado = produto.status;
    _custoController.text = produto.custo?.toString() ?? '';
    _codigoBarraController.text = produto.codigoBarra ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Produto'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _unidadeSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Unidade *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'un', child: Text('Unidade')),
                  DropdownMenuItem(value: 'cx', child: Text('Caixa')),
                  DropdownMenuItem(value: 'kg', child: Text('Quilograma')),
                  DropdownMenuItem(value: 'lt', child: Text('Litro')),
                  DropdownMenuItem(value: 'ml', child: Text('Mililitro')),
                ],
                onChanged: (value) {
                  setState(() {
                    _unidadeSelecionada = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantidadeController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade em Estoque *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precoVendaController,
                decoration: const InputDecoration(
                  labelText: 'Preço de Venda *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço de venda';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _statusSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Ativo')),
                  DropdownMenuItem(value: 1, child: Text('Inativo')),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusSelecionado = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _custoController,
                decoration: const InputDecoration(
                  labelText: 'Custo',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _codigoBarraController,
                decoration: const InputDecoration(
                  labelText: 'Código de Barra',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _limparCampos();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final produtoAtualizado = Produto(
                  id: produto.id,
                  nome: _nomeController.text,
                  unidade: _unidadeSelecionada,
                  quantidadeEstoque: double.parse(_quantidadeController.text),
                  precoVenda: double.parse(_precoVendaController.text),
                  status: _statusSelecionado,
                  custo: _custoController.text.isEmpty ? null : double.parse(_custoController.text),
                  codigoBarra: _codigoBarraController.text.isEmpty ? null : _codigoBarraController.text,
                );

                await ProdutoController.updateProduto(produtoAtualizado);
                await _carregarProdutos();
                _limparCampos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produto atualizado com sucesso')),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Produtos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _unidadeSelecionada,
                        decoration: const InputDecoration(
                          labelText: 'Unidade *',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'un', child: Text('Unidade')),
                          DropdownMenuItem(value: 'cx', child: Text('Caixa')),
                          DropdownMenuItem(value: 'kg', child: Text('Quilograma')),
                          DropdownMenuItem(value: 'lt', child: Text('Litro')),
                          DropdownMenuItem(value: 'ml', child: Text('Mililitro')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _unidadeSelecionada = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quantidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade em Estoque *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a quantidade';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Por favor, insira um número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _precoVendaController,
                        decoration: const InputDecoration(
                          labelText: 'Preço de Venda *',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o preço de venda';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Por favor, insira um número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _custoController,
                        decoration: const InputDecoration(
                          labelText: 'Custo',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _codigoBarraController,
                        decoration: const InputDecoration(
                          labelText: 'Código de Barras',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _statusSelecionado,
                        decoration: const InputDecoration(
                          labelText: 'Status *',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Ativo')),
                          DropdownMenuItem(value: 1, child: Text('Inativo')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _statusSelecionado = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _salvarProduto,
                        child: const Text('Salvar'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Voltar para Home'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Produtos Cadastrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  final produto = _produtos[index];
                  return ListTile(
                    title: Text(produto.nome),
                    subtitle: Text(
                      'Estoque: ${produto.quantidadeEstoque} ${produto.unidade} - '
                      'Preço: R\$ ${produto.precoVenda.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _precoVendaController.dispose();
    _custoController.dispose();
    _codigoBarraController.dispose();
    super.dispose();
  }
} 