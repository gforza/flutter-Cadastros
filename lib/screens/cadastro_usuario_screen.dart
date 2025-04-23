import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../controllers/app_controller.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _appController = AppController();
  List<Usuario> _usuarios = [];
  Usuario? _usuarioEmEdicao;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    final usuarios = await _appController.getUsuarios();
    setState(() {
      _usuarios = usuarios;
    });
  }

  Future<void> _salvarUsuario() async {
    if (_formKey.currentState!.validate()) {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('As senhas não coincidem'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_usuarioEmEdicao != null) {
        // Atualizar usuário existente
        final usuarioAtualizado = Usuario(
          id: _usuarioEmEdicao!.id,
          nome: _nomeController.text,
          senha: _senhaController.text,
        );

        await _appController.updateUsuario(usuarioAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário atualizado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Criar novo usuário
        final novoUsuario = Usuario(
          id: _usuarios.isEmpty ? 1 : _usuarios.last.id + 1,
          nome: _nomeController.text,
          senha: _senhaController.text,
        );

        await _appController.addUsuario(novoUsuario);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário cadastrado com sucesso'),
            backgroundColor: Colors.green,
          ),
        );
      }

      await _carregarUsuarios();
      _limparCampos();
    }
  }

  Future<void> _excluirUsuario(int id) async {
    await _appController.deleteUsuario(id);
    await _carregarUsuarios();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário excluído com sucesso'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _editarUsuario(Usuario usuario) {
    setState(() {
      _usuarioEmEdicao = usuario;
      _nomeController.text = usuario.nome;
      _senhaController.text = usuario.senha;
      _confirmarSenhaController.text = usuario.senha;
    });
  }

  void _visualizarUsuario(Usuario usuario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalhes do Usuário'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: ${usuario.nome}'),
              const SizedBox(height: 8),
              Text('ID: ${usuario.id}'),
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
      _usuarioEmEdicao = null;
      _nomeController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_usuarioEmEdicao == null ? 'Cadastro de Usuários' : 'Editar Usuário'),
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
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha *',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Senha *',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirme a senha';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _salvarUsuario,
                        child: Text(_usuarioEmEdicao == null ? 'Salvar' : 'Atualizar'),
                      ),
                      if (_usuarioEmEdicao != null)
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
              'Usuários Cadastrados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _usuarios[index];
                  return ListTile(
                    title: Text(usuario.nome),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () => _visualizarUsuario(usuario),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editarUsuario(usuario),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _excluirUsuario(usuario.id),
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
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }
} 