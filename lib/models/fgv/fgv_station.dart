// To parse this JSON data, do
//
//     final fgvStation = fgvStationFromJson(jsonString);

import 'dart:convert';

FgvStation fgvStationFromJson(String str) =>
    FgvStation.fromJson(json.decode(str));

String fgvStationToJson(FgvStation data) => json.encode(data.toJson());

class FgvStation {
  FgvStation({
    required this.id,
    required this.estacionIdFgv,
    required this.nombre,
    required this.transbordo,
    required this.latitud,
    required this.longitud,
    required this.direccion,
    required this.sede,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.distanciaActual,
  });

  int id;
  int estacionIdFgv;
  String nombre;
  int transbordo;
  double latitud;
  double longitud;
  String direccion;
  String sede;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  double? distanciaActual;

  factory FgvStation.fromJson(Map<String, dynamic> json) => FgvStation(
        id: json["id"],
        estacionIdFgv: json["estacion_id_FGV"],
        nombre: json["nombre"],
        transbordo: json["transbordo"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        direccion: json["direccion"],
        sede: json["sede"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        distanciaActual: json["distancia_actual"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "estacion_id_FGV": estacionIdFgv,
        "nombre": nombre,
        "transbordo": transbordo,
        "latitud": latitud,
        "longitud": longitud,
        "direccion": direccion,
        "sede": sede,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "distancia_actual": distanciaActual,
      };
}
