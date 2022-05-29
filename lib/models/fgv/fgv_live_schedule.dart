// To parse this JSON data, do
//
//     final fgvLiveSchedule = fgvLiveScheduleFromJson(jsonString);

import 'dart:convert';

List<FgvLiveSchedule> fgvLiveScheduleFromJson(String str) => List<FgvLiveSchedule>.from(json.decode(str).map((x) => FgvLiveSchedule.fromJson(x)));

String fgvLiveScheduleToJson(List<FgvLiveSchedule> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FgvLiveSchedule {
    FgvLiveSchedule({
        required this.lineId,
        required this.line,
        required this.trains,
        required this.lineaIdInterna,
    });

    int lineId;
    int line;
    List<Train>? trains;
    int lineaIdInterna;

    factory FgvLiveSchedule.fromJson(Map<String, dynamic> json) => FgvLiveSchedule(
        
        lineId: json["line_id"],
        line: json["line"],
        trains: json["trains"] == null ? null : List<Train>.from(json["trains"].map((x) => Train.fromJson(x))),
        lineaIdInterna: json["linea_id_interna"],
    );

    Map<String, dynamic> toJson() => {
        "line_id": lineId,
        "line": line,
        "trains": trains == null ? null : List<dynamic>.from(trains!.map((x) => x.toJson())),
        "linea_id_interna": lineaIdInterna,
    };
}

class Train {
    Train({
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
    Composition? composition;
    String destino;
    double? latitude;
    double? longitude;
    int? meters;
    int seconds;
    int? vehicle;
    int lineId;
    int? capacity;

    factory Train.fromJson(Map<String, dynamic> json) => Train(
        cabecera: json["cabecera"],
        composition: json["composition"] == null ? null : Composition.fromJson(json["composition"]),
        destino: json["destino"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
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

class Composition {
    Composition({
        required this.id,
        required this.updateTime,
        required this.compositionId,
        required this.head,
        required this.tail,
    });

    int id;
    DateTime? updateTime;
    int compositionId;
    int head;
    int tail;

    factory Composition.fromJson(Map<String, dynamic> json) => Composition(
        id: json["Id"],
        updateTime: json["UpdateTime"] == null ? null : DateTime.parse(json["UpdateTime"]),
        compositionId: json["_Id"],
        head: json["Head"],
        tail: json["Tail"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "UpdateTime": updateTime == null ? null : updateTime?.toIso8601String(),
        "_Id": compositionId,
        "Head": head,
        "Tail": tail,
    };
}
