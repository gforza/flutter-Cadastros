import 'package:flutter/material.dart';
import 'cadastro_usuario_screen.dart';
import 'cadastro_cliente_screen.dart';
import 'cadastro_produto_screen.dart';
import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Força de Vendas'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildMenuCard(
            context,
            'Usuários',
            Icons.person,
            const CadastroUsuarioScreen(),
          ),
          _buildMenuCard(
            context,
            'Clientes',
            Icons.people,
            const CadastroClienteScreen(),
          ),
          _buildMenuCard(
            context,
            'Produtos',
            Icons.shopping_cart,
            const CadastroProdutoScreen(),
          ),
          _buildMenuCard(
            context,
            'Sair',
            Icons.logout,
            const LoginScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return Card(
      child: InkWell(
        onTap: () {
          if (screen is LoginScreen) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }
} 