import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guia_hoteis_processo/common/domain/models/desconto_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/periodo_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/suite_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/view/ir_agora_page.dart';
import 'package:guia_hoteis_processo/common/features/ir_agora/viewmodel/ir_agora_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockMotelRepository extends Mock implements MotelRepository {}

class MockViewModel extends Mock implements IrAgoraViewModel {}

void main() {
  late IrAgoraViewModel viewModel;
  late MockMotelRepository mockMotelRepository;

  setUp(() {
    mockMotelRepository = MockMotelRepository();
    viewModel = MockViewModel();
  });

  group('IrAgoraPage Widget Tests', () {
    testWidgets('Mostrando circularProgress', (tester) async {
      when(() => viewModel.isLoading).thenReturn(true);
      when(() => viewModel.moteis).thenReturn([]);
      when(() => viewModel.discountedSuites).thenReturn([]);

      await tester.pumpWidget(MaterialApp(
        home: IrAgoraPage(viewModel: viewModel),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostrar "Sem suíte com desconto"', (WidgetTester tester) async {
      when(() => viewModel.isLoading).thenReturn(false);
      when(() => viewModel.moteis).thenReturn([]);
      when(() => viewModel.discountedSuites).thenReturn([]);

      await tester.pumpWidget(MaterialApp(
        home: IrAgoraPage(viewModel: viewModel),
      ));

      expect(find.text("Sem suíte com desconto"), findsOneWidget);
    });

    testWidgets('mostra os moteis com desconto', (WidgetTester tester) async {
      final discountedSuites = [
        DiscountedSuiteItem(
          motel: Motel(
            fantasia: "",
            logo: "",
            bairro: "",
            distancia: 0.0,
            qtdAvaliacoes: 0,
            qtdFavoritos: 0,
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
                    tempoFormatado: '1h',
                    valor: 100.0,
                    temCortesia: true,
                    tempo: "",
                    valorTotal: 0,
                    desconto: Desconto(desconto: 10.0),
                  ),
                ],
              ),
            ],
          ),
          suite: Suite(
            qtd: 0,
            exibirQtdDisponiveis: true,
            nome: 'Suite 1',
            fotos: [],
            itens: [],
            categoriaItens: [],
            periodos: [
              Periodo(
                tempoFormatado: '1h',
                valor: 100.0,
                tempo: "",
                valorTotal: 0.0,
                temCortesia: true,
                desconto: Desconto(desconto: 10.0),
              ),
            ],
          ),
          periodo: Periodo(
            tempo: "",
            tempoFormatado: "",
            valor: 0.0,
            valorTotal: 0.0,
            temCortesia: true,
          ),
        ),
      ];

      when(() => viewModel.isLoading).thenReturn(false);
      when(() => viewModel.moteis).thenReturn([]);
      when(() => viewModel.discountedSuites).thenReturn(discountedSuites);

      await tester.pumpWidget(MaterialApp(
        home: IrAgoraPage(viewModel: viewModel),
      ));

      expect(find.byType(PageView), findsOneWidget);
      expect(find.text("Suite 1"), findsOneWidget);
    });

    testWidgets('mostra os moteis no listView ', (WidgetTester tester) async {
      final moteis = [
        Motel(
          fantasia: "",
          logo: "",
          bairro: "",
          distancia: 0.0,
          qtdAvaliacoes: 0,
          qtdFavoritos: 0,
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
                Periodo(tempoFormatado: '1h', valor: 100.0, desconto: Desconto(desconto: 10.0), tempo: "", valorTotal: 0.0, temCortesia: true),
              ],
            ),
          ],
        ),
      ];

      when(() => viewModel.isLoading).thenReturn(false);
      when(() => viewModel.moteis).thenReturn(moteis);
      when(() => viewModel.discountedSuites).thenReturn([]);

      await tester.pumpWidget(MaterialApp(
        home: IrAgoraPage(viewModel: viewModel),
      ));

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text("Motel 1"), findsOneWidget);
    });
  });
}
