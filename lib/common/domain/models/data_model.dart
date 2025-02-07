import 'motel_model.dart';

class Data {
  final int pagina;
  final int qtdPorPagina;
  final int totalSuites;
  final int totalMoteis;
  final int raio;
  final double maxPaginas;
  final List<Motel> moteis;

  Data({
    required this.pagina,
    required this.qtdPorPagina,
    required this.totalSuites,
    required this.totalMoteis,
    required this.raio,
    required this.maxPaginas,
    required this.moteis,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      pagina: json['pagina'],
      qtdPorPagina: json['qtdPorPagina'],
      totalSuites: json['totalSuites'],
      totalMoteis: json['totalMoteis'],
      raio: json['raio'],
      maxPaginas: json['maxPaginas'],
      moteis: List<Motel>.from(json['moteis'].map((x) => Motel.fromJson(x))),
    );
  }
}
