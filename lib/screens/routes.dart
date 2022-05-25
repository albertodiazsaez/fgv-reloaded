import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/screens/stations/stations.dart';
import 'package:metrovalencia_reloaded/screens/transport-cards/check_transport_cards.dart';

class RouteCheckTransportCards extends StatelessWidget {
  const RouteCheckTransportCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('transportCards.title'))),
      body: const CheckTransportCards(),
    );
  }
}

class RouteStations extends StatelessWidget {
  const RouteStations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('stations.title'))),
      body: const Stations(),
    );
  }
}






