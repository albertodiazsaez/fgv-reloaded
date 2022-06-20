import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/timetable/timetable_screen.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';

class StationLines extends StatelessWidget {
  const StationLines({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      ('station.line').plural(station.lines!.length),
                      textScaleFactor: 1.2,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      for (var line in station.lines!)
                        LineNumber(line.id, HexColor(line.color), 25)
                    ],
                  )
                ],
              ),
            ),
            IconButton(
                splashRadius: 20,
                onPressed: () => _checkStationTimetable(context),
                icon: const Icon(Icons.calendar_month))
          ],
        ),
      ),
    );
  }

  Set<Future<Set<Station>>> _checkStationTimetable(BuildContext context) {
    return {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (
            context,
            animation1,
            animation2,
          ) =>
              RouteCheckStationTimetable(station),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then(
        (value) => {value as Station},
      )
    };
  }
}

class RouteCheckStationTimetable extends StatelessWidget {
  const RouteCheckStationTimetable(this.station, {Key? key}) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('timetable.title'))),
      body: TimetableScreen(inputOriginStation: station),
    );
  }
}
