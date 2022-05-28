import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';

class StationScreen extends StatefulWidget {
  const StationScreen(this.station, {Key? key}) : super(key: key);

  @override
  State<StationScreen> createState() => _StationScreenState();

  final Station station;
}

class _StationScreenState extends State<StationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Líneas: "),
            Row(
              children: <Widget>[
                for (var line in widget.station.lines!)
                  LineNumber(line.id, HexColor(line.color), 25)
              ],
            )
          ],
        )
      ],
    );
  }
}
