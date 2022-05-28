import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metrovalencia_reloaded/components/station_selector.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/routes.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({Key? key}) : super(key: key);

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  @override
  Widget build(BuildContext context) {
    return StationSelector(onStationSelected);
  }

  onStationSelected(Station stationSelected) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                RouteStation(stationSelected),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero));
  }
}
