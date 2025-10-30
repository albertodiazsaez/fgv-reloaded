// To parse this JSON data, do
//
//     final fgvNearbyStation = fgvNearbyStationFromJson(jsonString);

import 'dart:convert';

import 'package:metrovalencia_reloaded/models/fgv/fgv_live_schedule.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_train.dart';

List<FgvNearbyStation> fgvNearbyStationFromJson(String str) =>
    List<FgvNearbyStation>.from(
        json.decode(str).map((x) => FgvNearbyStation.fromJson(x)));

String fgvNearbyStationToJson(List<FgvNearbyStation> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FgvNearbyStation {
  FgvNearbyStation({
    required this.estacion,
    required this.previsiones,
    required this.aforoBloqueado,
    required this.configuracionAforo,
  });

  FgvStation estacion;
  List<FgvLiveSchedule> previsiones;
  AforoBloqueado aforoBloqueado;
  ConfiguracionAforo configuracionAforo;

  factory FgvNearbyStation.fromJson(Map<String, dynamic> json) =>
      FgvNearbyStation(
        estacion: FgvStation.fromJson(json["estacion"]),
        previsiones: List<FgvLiveSchedule>.from(
            json["previsiones"].map((x) => FgvLiveSchedule.fromJson(x))),
        aforoBloqueado: AforoBloqueado.fromJson(json["aforo_bloqueado"]),
        configuracionAforo:
            ConfiguracionAforo.fromJson(json["configuracion_aforo"]),
      );

  Map<String, dynamic> toJson() => {
        "estacion": estacion.toJson(),
        "previsiones": List<dynamic>.from(previsiones.map((x) => x.toJson())),
        "aforo_bloqueado": aforoBloqueado.toJson(),
        "configuracion_aforo": configuracionAforo.toJson(),
      };
}

class AforoBloqueado {
  AforoBloqueado({
    this.desde,
    this.hasta,
  });

  dynamic desde;
  dynamic hasta;

  factory AforoBloqueado.fromJson(Map<String, dynamic> json) => AforoBloqueado(
        desde: json["desde"],
        hasta: json["hasta"],
      );

  Map<String, dynamic> toJson() => {
        "desde": desde,
        "hasta": hasta,
      };
}

class ConfiguracionAforo {
  ConfiguracionAforo({
    required this.es,
    required this.en,
    required this.ca,
  });

  List<Ca> es;
  List<Ca> en;
  List<Ca> ca;

  factory ConfiguracionAforo.fromJson(Map<String, dynamic> json) =>
      ConfiguracionAforo(
        es: List<Ca>.from(json["es"].map((x) => Ca.fromJson(x))),
        en: List<Ca>.from(json["en"].map((x) => Ca.fromJson(x))),
        ca: List<Ca>.from(json["ca"].map((x) => Ca.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "es": List<dynamic>.from(es.map((x) => x.toJson())),
        "en": List<dynamic>.from(en.map((x) => x.toJson())),
        "ca": List<dynamic>.from(ca.map((x) => x.toJson())),
      };
}

class Ca {
  Ca({
    required this.tipoInformacion,
    required this.literal,
    required this.color,
    required this.limiteInferior,
    required this.limiteSuperior,
  });

  TipoInformacion tipoInformacion;
  String literal;
  Color color;
  String limiteInferior;
  String limiteSuperior;

  factory Ca.fromJson(Map<String, dynamic> json) => Ca(
        tipoInformacion: tipoInformacionValues.map[json["tipo_informacion"]]!,
        literal: json["literal"],
        color: colorValues.map[json["color"]]!,
        limiteInferior: json["limiteInferior"],
        limiteSuperior: json["limiteSuperior"],
      );

  Map<String, dynamic> toJson() => {
        "tipo_informacion": tipoInformacionValues.reverse[tipoInformacion],
        "literal": literal,
        "color": colorValues.reverse[color],
        "limiteInferior": limiteInferior,
        "limiteSuperior": limiteSuperior,
      };
}

enum Color { THE_008_F71, FEC601, DD052_C }

final colorValues = EnumValues({
  "#DD052C": Color.DD052_C,
  "#FEC601": Color.FEC601,
  "#008F71": Color.THE_008_F71
});

enum TipoInformacion { LITERAL }

final tipoInformacionValues = EnumValues({"literal": TipoInformacion.LITERAL});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
