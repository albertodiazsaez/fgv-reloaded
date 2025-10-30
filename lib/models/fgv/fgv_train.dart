import 'package:metrovalencia_reloaded/models/fgv/fgv_composition.dart';

class FgvTrain {
  FgvTrain({
    required this.cabecera,
    required this.composition,
    required this.destino,
    required this.latitude,
    required this.longitude,
    required this.meters,
    required this.seconds,
    required this.vehicle,
    required this.lineId,
    required this.capacity,
  });

  bool cabecera;
  FgvComposition? composition;
  String destino;
  double? latitude;
  double? longitude;
  int? meters;
  int seconds;
  int? vehicle;
  int lineId;
  int? capacity;

  factory FgvTrain.fromJson(Map<String, dynamic> json) => FgvTrain(
        cabecera: json["cabecera"],
        composition: json["composition"] == null
            ? null
            : FgvComposition.fromJson(json["composition"]),
        destino: json["destino"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude:
            json["longitude"] == null ? null : json["longitude"].toDouble(),
        meters: json["meters"],
        seconds: json["seconds"],
        vehicle: json["vehicle"],
        lineId: json["line_id"],
        capacity: json["capacity"],
      );

  Map<String, dynamic> toJson() => {
        "cabecera": cabecera,
        "composition": composition == null ? null : composition?.toJson(),
        "destino": destino,
        "latitude": latitude,
        "longitude": longitude,
        "meters": meters,
        "seconds": seconds,
        "vehicle": vehicle,
        "line_id": lineId,
        "capacity": capacity,
      };
}
