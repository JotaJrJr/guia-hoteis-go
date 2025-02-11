import 'package:flutter_test/flutter_test.dart';
import 'package:guia_hoteis_processo/common/domain/models/desconto_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/periodo_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/suite_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late IrAgoraViewModel viewModel;
  var repository = MockMotelRepository();

  setUp(() {
    viewModel = IrAgoraViewModel(repository);
  });

  group('IrAgoraViewModel Tests', () {
    test('init state', () {
      expect(viewModel.moteis, isEmpty);
      expect(viewModel.discountedSuites, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });

    test('getMoteis pega os moteis e filtra pelo filtro lá', () async {
      // Arrange
      final motels = [
        Motel(
          fantasia: "",
          logo: "",
          bairro: "",
          distancia: 0.0,
          qtdFavoritos: 0,
          qtdAvaliacoes: 0,
          media: 0.0,
          suites: [
            Suite(
              nome: 'Suite 1',
              fotos: [],
              itens: [],
              categoriaItens: [],
              qtd: 0,
              exibirQtdDisponiveis: true,
              periodos: [
                Periodo(
                  tempo: "",
                  valorTotal: 10,
                  temCortesia: true,
                  tempoFormatado: '1h',
                  valor: 100.0,
                  desconto: Desconto(desconto: 10.0),
                ),
              ],
            ),
          ],
        ),
      ];

      // when(repository.getMoteis()).thenAnswer((_) async => motels);
      when(repository.getMoteis).thenAnswer((_) async => motels);

      await viewModel.getMoteis();

      expect(viewModel.moteis, equals(motels));
      expect(viewModel.discountedSuites.length, equals(1));
      expect(viewModel.isLoading, isFalse);
    });

    test('getMoteis dá erro', () async {
      when(repository.getMoteis).thenThrow(Exception('Deu ruim ein galera'));

      await viewModel.getMoteis();

      expect(viewModel.moteis, isEmpty);
      expect(viewModel.discountedSuites, isEmpty);
      expect(viewModel.isLoading, isFalse);
    });
  });
}

class MockMotelRepository extends Mock implements MotelRepository {}
