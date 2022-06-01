import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

class StationAdress extends StatelessWidget {
  const StationAdress({
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('station.address'),
              textScaleFactor: 1.2,
            ),
            Text(
              station.adress,
            ),
          ],
        ),
      ),
    );
  }
}
