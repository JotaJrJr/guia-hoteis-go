import 'categoria_item_model.dart';
import 'item_model.dart';
import 'periodo_model.dart';

class Suite {
  final String nome;
  final int qtd;
  final bool exibirQtdDisponiveis;
  final List<String> fotos;
  final List<Item> itens;
  final List<CategoriaItem> categoriaItens;
  final List<Periodo> periodos;

  Suite({
    required this.nome,
    required this.qtd,
    required this.exibirQtdDisponiveis,
    required this.fotos,
    required this.itens,
    required this.categoriaItens,
    required this.periodos,
  });

  factory Suite.fromJson(Map<String, dynamic> json) {
    return Suite(
      nome: json['nome'],
      qtd: json['qtd'],
      exibirQtdDisponiveis: json['exibirQtdDisponiveis'],
      fotos: List<String>.from(json['fotos']),
      itens: List<Item>.from(json['itens'].map((x) => Item.fromJson(x))),
      categoriaItens: List<CategoriaItem>.from(json['categoriaItens'].map((x) => CategoriaItem.fromJson(x))),
      periodos: List<Periodo>.from(json['periodos'].map((x) => Periodo.fromJson(x))),
    );
  }
}
