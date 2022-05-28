import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';

class StationCard extends StatelessWidget {
  const StationCard(
    this.station, {
    Key? key,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 2.5),
                child: Text(
                  station.name,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 5),
                child: Row(
                  children: <Widget>[
                    for (var line in station.lines!)
                      LineNumber(line.id, HexColor(line.color), 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
