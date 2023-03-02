class FgvComposition {
  FgvComposition({
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

  factory FgvComposition.fromJson(Map<String, dynamic> json) => FgvComposition(
        id: json["Id"],
        updateTime: json["UpdateTime"] == null
            ? null
            : DateTime.parse(json["UpdateTime"]),
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
