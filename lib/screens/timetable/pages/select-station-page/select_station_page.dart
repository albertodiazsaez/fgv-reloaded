import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/station_selector.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

class SelectStationPage extends StatefulWidget {
  const SelectStationPage({Key? key}) : super(key: key);

  @override
  State<SelectStationPage> createState() => _SelectStationPageState();
}

class _SelectStationPageState extends State<SelectStationPage> {
  @override
  Widget build(BuildContext context) {
    return StationSelector(_onStationSelected);
  }

  _onStationSelected(Station station) {
    Navigator.pop(context, station);
  }
}