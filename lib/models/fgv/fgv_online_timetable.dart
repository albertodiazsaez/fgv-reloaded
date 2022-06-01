import 'dart:convert';

import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';

FgvOnlineTimetable fgvOnlineTimetableFromJson(String str) => FgvOnlineTimetable.fromJson(json.decode(str));

String fgvOnlineTimetableToJson(FgvOnlineTimetable data) => json.encode(data.toJson());

class FgvOnlineTimetable {
    FgvOnlineTimetable({
        this.status,
        this.error,
        this.resultado,
    });

    int? status;
    int? error;
    Resultado? resultado;

    factory FgvOnlineTimetable.fromJson(Map<String, dynamic> json) => FgvOnlineTimetable(
        status: json["status"],
        error: json["error"],
        resultado: json["resultado"] == null ? null : Resultado.fromJson(json["resultado"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "resultado": resultado?.toJson(),
    };
}

class Resultado {
    Resultado({
        this.estacionOrigen,
        this.estacionDestino,
        this.tarifas,
        this.huellaDeCarbono,
        this.duracionMinutos,
        this.distancia,
        this.transbordos,
    });

    FgvStation? estacionOrigen;
    FgvStation? estacionDestino;
    String? tarifas;
    double? huellaDeCarbono;
    int? duracionMinutos;
    int? distancia;
    List<Transbordo>? transbordos;

    factory Resultado.fromJson(Map<String, dynamic> json) => Resultado(
        estacionOrigen: json["estacion_origen"] == null ? null : FgvStation.fromJson(json["estacion_origen"]),
        estacionDestino: json["estacion_destino"] == null ? null : FgvStation.fromJson(json["estacion_destino"]),
        tarifas: json["tarifas"],
        huellaDeCarbono: json["huella_de_carbono"].toDouble(),
        duracionMinutos: json["duracion_minutos"],
        distancia: json["distancia"],
        transbordos: json["transbordos"] == null ? null : List<Transbordo>.from(json["transbordos"].map((x) => Transbordo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "estacion_origen": estacionOrigen?.toJson(),
        "estacion_destino": estacionDestino?.toJson(),
        "tarifas": tarifas,
        "huella_de_carbono": huellaDeCarbono,
        "duracion_minutos": duracionMinutos,
        "distancia": distancia,
        "transbordos": transbordos == null ? null : List<dynamic>.from(transbordos!.map((x) => x.toJson())),
    };
}

class Transbordo {
    Transbordo({
        this.estacionOrigenTransbordo,
        this.estacionDestinoTransbordo,
        this.lineas,
        this.destinos,
        this.horas,
    });

    FgvStation? estacionOrigenTransbordo;
    FgvStation? estacionDestinoTransbordo;
    List<dynamic>? lineas;
    List<String>? destinos;
    Map<String, List<String>>? horas;

    factory Transbordo.fromJson(Map<String, dynamic> json) => Transbordo(
        estacionOrigenTransbordo: json["estacion_origen_transbordo"] == null ? null : FgvStation.fromJson(json["estacion_origen_transbordo"]),
        estacionDestinoTransbordo: json["estacion_destino_transbordo"] == null ? null : FgvStation.fromJson(json["estacion_destino_transbordo"]),
        lineas: json["lineas"] == null ? null : List<dynamic>.from(json["lineas"].map((x) => x)),
        destinos: json["destinos"] == null ? null : List<String>.from(json["destinos"].map((x) => x)),
        horas: json["horas"] == null ? null : Map.from(json["horas"]).map((k, v) => MapEntry<String, List<String>>(k, List<String>.from(v.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "estacion_origen_transbordo": estacionOrigenTransbordo?.toJson(),
        "estacion_destino_transbordo": estacionDestinoTransbordo?.toJson(),
        "lineas": lineas == null ? null : List<dynamic>.from(lineas!.map((x) => x)),
        "destinos": destinos == null ? null : List<dynamic>.from(destinos!.map((x) => x)),
        "horas": horas == null ? null : Map.from(horas!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
    };
}
