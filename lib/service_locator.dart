import 'package:metrovalencia_reloaded/services/metrovalencia/metrovalencia_transport_card_service.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<AbstractMetrovalenciaTransportCardService>(() => MetrovalenciaTransportCardService());
}