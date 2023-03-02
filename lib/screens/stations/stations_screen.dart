import 'package:flutter/material.dart';

import 'package:metrovalencia_reloaded/components/station-selector/station_selector.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/routes.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({Key? key}) : super(key: key);

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen>
    with AutomaticKeepAliveClientMixin<StationsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StationSelector(onStationSelected);
  }

  onStationSelected(Station stationSelected) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RouteStation(stationSelected)));
  }
}
