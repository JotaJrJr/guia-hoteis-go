import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/periodo_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/suite_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';

class IrAgoraViewModel extends ChangeNotifier {
  final MotelRepository _repository;

  final PageController pageController = PageController(initialPage: 0);

  IrAgoraViewModel(this._repository);

  List<Motel> _moteis = [];
  List<Motel> get moteis => _moteis;

  List<DiscountedSuiteItem> _discountedSuites = [];
  List<DiscountedSuiteItem> get discountedSuites => _discountedSuites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> getMoteis() async {
    _isLoading = true;
    notifyListeners();

    try {
      _moteis = await _repository.getMoteis();
      _filterSuitesComDesconto();
    } catch (e) {
      debugPrint("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Iterable<DiscountedSuiteItem> getSuitesWithDiscount(Motel motel) {
    return motel.suites.expand((suite) {
      return suite.periodos.where((element) => element.desconto != null).map((periodo) {
        return DiscountedSuiteItem(motel: motel, suite: suite, periodo: periodo);
      });
    });
  }

  void _filterSuitesComDesconto() {
    _discountedSuites = _moteis.expand((motel) => getSuitesWithDiscount(motel)).toList();

    notifyListeners();
  }
}

class DiscountedSuiteItem {
  final Motel motel;
  final Suite suite;
  final Periodo periodo;

  double get discountValue => periodo.desconto!.desconto;
  double get originalPrice => periodo.valor;

  double get discountPercentage => (discountValue / originalPrice) * 100;

  DiscountedSuiteItem({
    required this.motel,
    required this.suite,
    required this.periodo,
  });
}
