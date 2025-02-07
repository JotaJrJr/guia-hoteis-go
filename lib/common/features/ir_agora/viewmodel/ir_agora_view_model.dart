import 'package:flutter/material.dart';
import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';
import 'package:guia_hoteis_processo/common/domain/models/suite_model.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';

class IrAgoraViewModel extends ChangeNotifier {
  final MotelRepository _repository;

  IrAgoraViewModel(this._repository);

  List<Motel> _moteis = [];
  List<Motel> get moteis => _moteis;

  List<DiscountedSuiteItem> _discountedSuites = [];
  List<DiscountedSuiteItem> get discountedSuites => _discountedSuites;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double _currentPage = 0.0;
  double get currentPage => _currentPage;

  void updateCurrentPage(double page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }

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

  void _filterSuitesComDesconto() {
    _discountedSuites = [];
    for (var motel in _moteis) {
      for (var suite in motel.suites) {
        if (suite.periodos.any((periodo) => periodo.desconto != null && periodo.desconto!.desconto > 0)) {
          _discountedSuites.add(
            DiscountedSuiteItem(
              motel: motel,
              suite: suite,
            ),
          );
          debugPrint(_discountedSuites.length.toString());
        }
      }
    }
    debugPrint(_discountedSuites.length.toString());

    notifyListeners();
  }
}

class DiscountedSuiteItem {
  final Motel motel;
  final Suite suite;

  DiscountedSuiteItem({
    required this.motel,
    required this.suite,
  });
}
