import 'package:metrovalencia_reloaded/models/fgv/fgv_live_schedule.dart';

class LiveDepartures {
  int lineId;
  String lineColor;
  String destination;
  double? latitude;
  double? longitude;
  int? meters;
  Duration timeToArrival;
  int? capacity;

  LiveDepartures(
    this.lineId,
    this.lineColor,
    this.destination,
    this.timeToArrival, [
    this.latitude,
    this.longitude,
    this.meters,
    this.capacity,
  ]) {}
}
