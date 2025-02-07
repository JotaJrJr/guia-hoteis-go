import 'package:guia_hoteis_processo/common/data/remote/api/hotel_api_service.dart';
import 'package:guia_hoteis_processo/common/domain/repositories/motel_repository.dart';

import '../../../domain/models/motel_model.dart';

class MotelRepositoryImpl implements MotelRepository {
  final HotelApiService _apiService;

  MotelRepositoryImpl(this._apiService);

  @override
  Future<List<Motel>> getMoteis() async {
    return await _apiService.getMoteis();
  }
}
