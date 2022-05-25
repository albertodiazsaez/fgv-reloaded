import 'package:metrovalencia_reloaded/environments/base_environment.dart';
import 'package:metrovalencia_reloaded/environments/prod_environment.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();

  static final Environment _singleton = Environment._internal();

  static const String DEV = 'DEV';
  static const String STAGING = 'STAGING';
  static const String PROD = 'PROD';

// Entorno por defecto
  BaseEnvironment properties = ProdEnvironment();

  initConfig(String environment) {
    properties = _getConfig(environment);
  }

  BaseEnvironment _getConfig(String environment) {
    switch (environment) {
      case Environment.PROD:
        return ProdEnvironment();
      default:
        return ProdEnvironment();
    }
  }

static String getFgvUrl() {
  return (Environment().properties.fgvHost + Environment().properties.apiBaseRoute);
}


}