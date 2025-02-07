class Item {
  final String nome;

  Item({
    required this.nome,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      nome: json['nome'],
    );
  }
}
