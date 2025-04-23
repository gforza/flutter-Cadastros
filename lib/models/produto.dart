class Produto {
  final int id;
  final String nome;
  final double preco;
  final int quantidade;

  Produto({
    required this.id,
    required this.nome,
    required this.preco,
    required this.quantidade,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      preco: json['preco'],
      quantidade: json['quantidade'],
    );
  }
} 