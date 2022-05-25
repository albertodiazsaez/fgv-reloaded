import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/screens/transportCards/check_transport_cards.dart';

class RouteCheckTransportCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('transportCards.title'))),
      body: const CheckTransportCards(),
    );
  }
}
