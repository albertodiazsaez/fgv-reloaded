// To parse this JSON data, do
//
//     final fgvLine = fgvLineFromJson(jsonString);

import 'dart:convert';

FgvLine fgvLineFromJson(String str) => FgvLine.fromJson(json.decode(str));

String fgvLineToJson(FgvLine data) => json.encode(data.toJson());

class FgvLine {
    FgvLine({
        required this.id,
        required this.lineaIdFgv,
        required this.nombreCorto,
        required this.nombreLargo,
        required this.tipo,
        required this.color,
        required this.formaId,
        required this.stops,
        required this.sede,
        required this.createdAt,
        required this.updatedAt,
        this.deletedAt,
    });

    int id;
    int lineaIdFgv;
    String nombreCorto;
    String nombreLargo;
    String tipo;
    String color;
    int formaId;
    String stops;
    String sede;
    DateTime createdAt;
    DateTime updatedAt;
    dynamic deletedAt;

    factory FgvLine.fromJson(Map<String, dynamic> json) => FgvLine(
        id: json["id"],
        lineaIdFgv: json["linea_id_FGV"],
        nombreCorto: json["nombre_corto"],
        nombreLargo: json["nombre_largo"],
        tipo: json["tipo"],
        color: json["color"],
        formaId: json["forma_id"],
        stops: json["stops"],
        sede: json["sede"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "linea_id_FGV": lineaIdFgv,
        "nombre_corto": nombreCorto,
        "nombre_largo": nombreLargo,
        "tipo": tipo,
        "color": color,
        "forma_id": formaId,
        "stops": stops,
        "sede": sede,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
    };
}
