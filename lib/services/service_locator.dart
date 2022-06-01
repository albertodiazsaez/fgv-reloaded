import 'package:get_it/get_it.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_live_schedule_service.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_station_service.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_transport_card_service.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<AbstractFgvTransportCardService>(() => FgvTransportCardService());
  getIt.registerLazySingleton<AbstractFgvStationService>(() => FgvStationService());
  getIt.registerLazySingleton<AbstractFgvLiveScheduleService>(() => FgvLiveScheduleServivce());
}