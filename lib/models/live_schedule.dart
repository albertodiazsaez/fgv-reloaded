class LiveSchedule {
  int lineId;
  String lineColor;
  String destination;
  double? latitude;
  double? longitude;
  int? meters;
  Duration timeToArrival;
  int? capacity;

  LiveSchedule(
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
