import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metrovalencia_reloaded/screens/routes.dart';
import 'package:metrovalencia_reloaded/screens/transportCards/check_transport_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('appTitle'))),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
                onPressed: (() => Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          RouteCheckTransportCards(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ))),
                child: Text(tr('transportCards.title'))),
          )
        ],
      ),
    );
  }
}
