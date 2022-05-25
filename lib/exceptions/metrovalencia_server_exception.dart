import 'package:easy_localization/easy_localization.dart';

class MetrovalenciaServerException implements Exception {

  @override
  String toString() {
    return tr('errors.metrovalenciaError');
  }
}
