import 'package:metrovalencia_reloaded/models/live_departures.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

class NearbyStation {
  Station station;
  List<LiveDepartures> liveDepartures;

  NearbyStation(
    this.station,
    this.liveDepartures,
  );
}
