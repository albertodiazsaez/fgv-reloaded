class LiveSchedule {
  int lineId;
  String destination;
  double? latitude;
  double? longitude;
  int? meters;
  Duration timeToArrival;
  int? capacity;

  LiveSchedule(
    this.lineId,
    this.destination,
    this.timeToArrival, [
    this.latitude,
    this.longitude,
    this.meters,
    this.capacity,
  ]) {}
}
