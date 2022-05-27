import 'package:metrovalencia_reloaded/models/station.dart';

class Line {

  int id;
  String shortName;
  String longName;
  String type;
  String color;
  int shapeId;
  String headquarters;
  List<Station>? stations;

  Line(
    this.id,
    this.shortName,
    this.longName,
    this.type,
    this.color,
    this.shapeId,
    this.headquarters,
    [this.stations]
  );

}
