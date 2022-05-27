import 'package:metrovalencia_reloaded/models/line.dart';

class Station {
  //ID FGV
  int id;
  String name;
  bool transfer;
  double latitude;
  double longitude;
  String adress;
  String headquarters;
  List<Line>? lines;

  Station(
    this.id,
    this.name,
    this.transfer,
    this.latitude,
    this.longitude,
    this.headquarters,
    this.adress,
    [this.lines]
  );
}
