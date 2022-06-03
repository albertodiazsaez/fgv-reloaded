import 'package:metrovalencia_reloaded/models/station.dart';

class Timetable {
  Station originStation;
  Station destinationStation;
  String zones;
  double carbonFootprint;
  int duration;
  int distance;
  List<Transfer> transfers;

  Timetable(
    this.originStation,
    this.destinationStation,
    this.zones,
    this.carbonFootprint,
    this.duration,
    this.distance,
    this.transfers,
  );
}

class Transfer {
  Station originStation;
  Station destinationStation;
  String possibleDestinations;
  Map<int, List<String>> departures;

  Transfer(
    this.originStation,
    this.destinationStation,
    this.possibleDestinations,
    this.departures,
  );
}
