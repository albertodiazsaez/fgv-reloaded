// To parse this JSON data, do
//
//     final fgvOnlineTimetable = fgvOnlineTimetableFromJson(jsonString);

import 'dart:convert';

import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';

FgvOnlineTimetable fgvOnlineTimetableFromJson(String str) => FgvOnlineTimetable.fromJson(json.decode(str));

String fgvOnlineTimetableToJson(FgvOnlineTimetable data) => json.encode(data.toJson());

class FgvOnlineTimetable {
    int status;
    int error;
    List<Resultado> resultado;

    FgvOnlineTimetable({
        required this.status,
        required this.error,
        required this.resultado,
    });

    factory FgvOnlineTimetable.fromJson(Map<String, dynamic> json) => FgvOnlineTimetable(
        status: json["status"],
        error: json["error"],
        resultado: List<Resultado>.from(json["resultado"].map((x) => Resultado.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "resultado": List<dynamic>.from(resultado.map((x) => x.toJson())),
    };
}

class Resultado {
    Titulo titulo;
    FgvStation estacionOrigen;
    FgvStation estacionDestino;
    String tarifas;
    double huellaDeCarbono;
    int duracionMinutos;
    int distancia;
    List<Transbordo> transbordos;
    String mensaje;

    Resultado({
        required this.titulo,
        required this.estacionOrigen,
        required this.estacionDestino,
        required this.tarifas,
        required this.huellaDeCarbono,
        required this.duracionMinutos,
        required this.distancia,
        required this.transbordos,
        required this.mensaje,
    });

    factory Resultado.fromJson(Map<String, dynamic> json) => Resultado(
        titulo: Titulo.fromJson(json["titulo"]),
        estacionOrigen: FgvStation.fromJson(json["estacion_origen"]),
        estacionDestino: FgvStation.fromJson(json["estacion_destino"]),
        tarifas: json["tarifas"],
        huellaDeCarbono: json["huella_de_carbono"]?.toDouble(),
        duracionMinutos: json["duracion_minutos"],
        distancia: json["distancia"],
        transbordos: List<Transbordo>.from(json["transbordos"].map((x) => Transbordo.fromJson(x))),
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "titulo": titulo.toJson(),
        "estacion_origen": estacionOrigen.toJson(),
        "estacion_destino": estacionDestino.toJson(),
        "tarifas": tarifas,
        "huella_de_carbono": huellaDeCarbono,
        "duracion_minutos": duracionMinutos,
        "distancia": distancia,
        "transbordos": List<dynamic>.from(transbordos.map((x) => x.toJson())),
        "mensaje": mensaje,
    };
}


enum Sede {
    V
}

final sedeValues = EnumValues({
    "V": Sede.V
});

class Titulo {
    String es;
    String vl;
    String en;

    Titulo({
        required this.es,
        required this.vl,
        required this.en,
    });

    factory Titulo.fromJson(Map<String, dynamic> json) => Titulo(
        es: json["ES"],
        vl: json["VL"],
        en: json["EN"],
    );

    Map<String, dynamic> toJson() => {
        "ES": es,
        "VL": vl,
        "EN": en,
    };
}

class Transbordo {
    FgvStation estacionOrigenTransbordo;
    FgvStation estacionDestinoTransbordo;
    List<dynamic> lineas;
    List<String> destinos;
    Map<String, List<String>> horas;

    Transbordo({
        required this.estacionOrigenTransbordo,
        required this.estacionDestinoTransbordo,
        required this.lineas,
        required this.destinos,
        required this.horas,
    });

    factory Transbordo.fromJson(Map<String, dynamic> json) => Transbordo(
        estacionOrigenTransbordo: FgvStation.fromJson(json["estacion_origen_transbordo"]),
        estacionDestinoTransbordo: FgvStation.fromJson(json["estacion_destino_transbordo"]),
        lineas: List<dynamic>.from(json["lineas"].map((x) => x)),
        destinos: List<String>.from(json["destinos"].map((x) => x)),
        horas: Map.from(json["horas"]).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "estacion_origen_transbordo": estacionOrigenTransbordo.toJson(),
        "estacion_destino_transbordo": estacionDestinoTransbordo.toJson(),
        "lineas": List<dynamic>.from(lineas.map((x) => x)),
        "destinos": List<dynamic>.from(destinos.map((x) => x)),
        "horas": Map.from(horas).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
