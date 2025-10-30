// To parse this JSON data, do
//
//     final fgvLiveSchedule = fgvLiveScheduleFromJson(jsonString);

import 'dart:convert';

import 'package:metrovalencia_reloaded/models/fgv/fgv_composition.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_train.dart';

List<FgvLiveSchedule> fgvLiveScheduleFromJson(String str) =>
    List<FgvLiveSchedule>.from(
        json.decode(str).map((x) => FgvLiveSchedule.fromJson(x)));

String fgvLiveScheduleToJson(List<FgvLiveSchedule> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FgvLiveSchedule {
  FgvLiveSchedule({
    required this.lineId,
    required this.line,
    required this.trains,
    required this.lineaIdInterna,
  });

  int lineId;
  int line;
  List<FgvTrain>? trains;
  int lineaIdInterna;

  factory FgvLiveSchedule.fromJson(Map<String, dynamic> json) =>
      FgvLiveSchedule(
        lineId: json["line_id"],
        line: json["line"],
        trains: json["trains"] == null
            ? null
            : List<FgvTrain>.from(
                json["trains"].map((x) => FgvTrain.fromJson(x))),
        lineaIdInterna: json["linea_id_interna"],
      );

  Map<String, dynamic> toJson() => {
        "line_id": lineId,
        "line": line,
        "trains": trains == null
            ? null
            : List<dynamic>.from(trains!.map((x) => x.toJson())),
        "linea_id_interna": lineaIdInterna,
      };
}
