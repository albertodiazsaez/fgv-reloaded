import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/station/station_screen.dart';
import 'package:metrovalencia_reloaded/screens/stations/stations_screen.dart';
import 'package:metrovalencia_reloaded/screens/timetable/timetable_screen.dart';

class RouteStations extends StatelessWidget {
  const RouteStations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('stations.title'))),
      body: const StationsScreen(),
    );
  }
}

class RouteStation extends StatelessWidget {
  const RouteStation(this.station, {Key? key}) : super(key: key);

  final Station station;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(station.name)),
      body: StationScreen(station),
    );
  }
}
