import 'package:guia_hoteis_processo/common/domain/models/motel_model.dart';

abstract class MotelRepository {
  Future<List<Motel>> getMoteis();
}
