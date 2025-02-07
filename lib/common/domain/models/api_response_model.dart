import 'data_model.dart';

class ApiResponse {
  final bool sucesso;
  final Data data;
  final List<dynamic> mensagem;

  ApiResponse({
    required this.sucesso,
    required this.data,
    required this.mensagem,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      sucesso: json['sucesso'],
      data: Data.fromJson(json['data']),
      mensagem: json['mensagem'],
    );
  }
}
