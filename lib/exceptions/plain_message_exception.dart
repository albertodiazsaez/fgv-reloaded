import 'package:easy_localization/easy_localization.dart';

class PlainMessageException implements Exception {
  String message;

  PlainMessageException(this.message) {}

  @override
  String toString() {
    return message;
  }
}
