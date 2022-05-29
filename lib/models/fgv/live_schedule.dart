class LiveSchedule {
  int lineId;
  String destination;
  double? latitude;
  double? longitude;
  int? meters;
  int seconds;
  int? capacity;

  LiveSchedule(
    this.lineId,
    this.destination,
    this.seconds, [
    this.latitude,
    this.longitude,
    this.meters,
    this.capacity,
  ]) {}
}
