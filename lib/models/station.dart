import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';
import 'package:metrovalencia_reloaded/models/line.dart';

class Station {
  //ID FGV
  int fgvId;
  int id;
  String name;
  bool transfer;
  double latitude;
  double longitude;
  String adress;
  String headquarters;
  List<Line>? lines;

  Station(
    this.fgvId,
    this.id,
    this.name,
    this.transfer,
    this.latitude,
    this.longitude,
    this.headquarters,
    this.adress, [
    this.lines,
  ]);

  static fgvStationToStation(FgvStation fgvStation) {
    return Station(
      fgvStation.estacionIdFgv,
      fgvStation.id,
      fgvStation.nombre,
      fgvStation.transbordo == 1,
      fgvStation.latitud,
      fgvStation.longitud,
      fgvStation.sede,
      fgvStation.direccion,
    );
  }
}
