import 'package:metrovalencia_reloaded/environments/base_environment.dart';

class ProdEnvironment implements BaseEnvironment {
  @override
  String get apiBaseRoute => 'ap18/api/public/es/api/v1/V/';

  @override
  String get fgvHost => 'https://www.fgv.es/';
  //String get fgvHost => 'http://192.168.1.135:3001/';
}
