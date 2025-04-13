# Aplicativo de Força de Vendas

Este é um aplicativo de força de vendas desenvolvido em Flutter para gerenciamento de usuários, clientes e produtos.

## Funcionalidades

- Login de usuários
- Cadastro de usuários (CRUD)
- Cadastro de clientes (CRUD)
- Cadastro de produtos (CRUD)
- Armazenamento local em arquivos JSON

## Estrutura do Projeto

```
lib/
├── controllers/     # Controladores para gerenciar as regras de negócio
├── models/          # Modelos de dados
├── screens/         # Telas do aplicativo
└── utils/          # Utilitários
```

## Requisitos

- Flutter SDK
- Dart SDK

## Instalação

1. Clone o repositório
2. Execute `flutter pub get` para instalar as dependências
3. Execute `flutter run` para iniciar o aplicativo

## Uso

1. Ao iniciar o aplicativo, use as credenciais:
   - Usuário: admin
   - Senha: admin

2. Após o login, você terá acesso ao menu principal com as opções:
   - Usuários
   - Clientes
   - Produtos

3. Em cada seção, você pode:
   - Adicionar novos registros
   - Visualizar registros existentes
   - Editar registros
   - Excluir registros

## Dependências

- path_provider: ^2.1.2
- flutter: SDK
- cupertino_icons: ^1.0.2
