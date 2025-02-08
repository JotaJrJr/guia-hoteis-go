import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';

class HotelApiService {
  Future<List<Motel>> getMoteis() async {
    final httpClient = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.getUrl(Uri.parse('https://jsonkeeper.com/b/1IXK'));
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();

      debugPrint(responseBody);

      var data = json.decode(responseBody);

      return (data['data']['moteis'] as List).map((json) => Motel.fromJson(json)).toList();
    } else {
      throw Exception('Deu ruim ein galera');
    }
  }
}
