import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../controllers/app_controller.dart';

class CadastroClienteScreen extends StatefulWidget {
  const CadastroClienteScreen({super.key});

  @override
  State<CadastroClienteScreen> createState() => _CadastroClienteScreenState();
}

class _CadastroClienteScreenState extends State<CadastroClienteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _appController = AppController();
  List<Cliente> _clientes = [];
  String _tipoSelecionado = 'PF';
  Cliente? _clienteEmEdicao;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final clientes = await _appController.getClientes();
    setState(() {
      _clientes = clientes;
    });
  }

  Future<void> _salvarCliente() async {
    if (_formKey.currentState!.validate()) {
      if (_clienteEmEdicao != null) {
        // Atualizar cliente existente
        final clienteAtualizado = Cliente(
          id: _clienteEmEdicao!.id,
          nome: _nomeController.text,
          cpfCnpj: _cpfCnpjController.text,
          email: _emailController.text,
          telefone: _telefoneController.text,
          endereco: _enderecoController.text,
          bairro: _bairroController.text,
          cidade: _cidadeController.text,
          tipo: _tipoSelecionado,
        );

        await _appController.updateCliente(clienteAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente atualizado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Criar novo cliente
        final novoCliente = Cliente(
          id: _clientes.isEmpty ? 1 : _clientes.last.id + 1,
          nome: _nomeController.text,
          cpfCnpj: _cpfCnpjController.text,
          email: _emailController.text,
          telefone: _telefoneController.text,
          endereco: _enderecoController.text,
          bairro: _bairroController.text,
          cidade: _cidadeController.text,
          tipo: _tipoSelecionado,
        );

        await _appController.addCliente(novoCliente);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cliente cadastrado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _carregarClientes();
      _limparCampos();
    }
  }

  Future<void> _excluirCliente(int id) async {
    await _appController.deleteCliente(id);
    await _carregarClientes();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cliente excluído com sucesso'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _editarCliente(Cliente cliente) {
    setState(() {
      _clienteEmEdicao = cliente;
      _nomeController.text = cliente.nome;
      _cpfCnpjController.text = cliente.cpfCnpj;
      _emailController.text = cliente.email ?? '';
      _telefoneController.text = cliente.telefone ?? '';
      _enderecoController.text = cliente.endereco ?? '';
      _bairroController.text = cliente.bairro ?? '';
      _cidadeController.text = cliente.cidade ?? '';
      _tipoSelecionado = cliente.tipo;
    });
  }

  void _visualizarCliente(Cliente cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Cliente'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: ${cliente.nome}'),
              const SizedBox(height: 8),
              Text('Tipo: ${cliente.tipo == 'PF' ? 'Pessoa Física' : 'Pessoa Jurídica'}'),
              const SizedBox(height: 8),
              Text('${cliente.tipo == 'PF' ? 'CPF' : 'CNPJ'}: ${cliente.cpfCnpj}'),
              const SizedBox(height: 8),
              Text('E-mail: ${cliente.email ?? ''}'),
              const SizedBox(height: 8),
              Text('Telefone: ${cliente.telefone ?? ''}'),
              const SizedBox(height: 8),
              Text('Endereço: ${cliente.endereco ?? ''}'),
              const SizedBox(height: 8),
              Text('Bairro: ${cliente.bairro ?? ''}'),
              const SizedBox(height: 8),
              Text('Cidade: ${cliente.cidade ?? ''}'),
            ],
          ),
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

  void _limparCampos() {
    setState(() {
      _clienteEmEdicao = null;
      _nomeController.clear();
      _cpfCnpjController.clear();
      _emailController.clear();
      _telefoneController.clear();
      _enderecoController.clear();
      _bairroController.clear();
      _cidadeController.clear();
      _tipoSelecionado = 'PF';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_clienteEmEdicao == null ? 'Cadastro de Clientes' : 'Editar Cliente'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome*',
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
                    value: _tipoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Tipo*',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'PF', child: Text('Pessoa Física')),
                      DropdownMenuItem(value: 'PJ', child: Text('Pessoa Jurídica')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _tipoSelecionado = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cpfCnpjController,
                    decoration: InputDecoration(
                      labelText: _tipoSelecionado == 'PF' ? 'CPF*' : 'CNPJ*',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o ${_tipoSelecionado == 'PF' ? 'CPF' : 'CNPJ'}';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _telefoneController,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bairroController,
                    decoration: const InputDecoration(
                      labelText: 'Bairro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _salvarCliente,
                        child: Text(_clienteEmEdicao == null ? 'Salvar' : 'Atualizar'),
                      ),
                      if (_clienteEmEdicao != null)
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
              'Clientes Cadastrados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _clientes.length,
                itemBuilder: (context, index) {
                  final cliente = _clientes[index];
                  return ListTile(
                    title: Text(cliente.nome),
                    subtitle: Text('${cliente.tipo == 'PF' ? 'CPF' : 'CNPJ'}: ${cliente.cpfCnpj}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _visualizarCliente(cliente),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editarCliente(cliente),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluirCliente(cliente.id),
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
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    super.dispose();
  }
} 