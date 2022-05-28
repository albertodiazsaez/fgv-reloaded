import 'package:easy_localization/easy_localization.dart';

class FgvServerException implements Exception {

  @override
  String toString() {
    return tr('errors.metrovalenciaError');
  }
}
