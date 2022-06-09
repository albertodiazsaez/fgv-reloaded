import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metrovalencia_reloaded/models/timetable.dart';

class TimetableCard extends StatelessWidget {
  const TimetableCard(this.timetable, {Key? key}) : super(key: key);

  final Timetable timetable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      child: Card(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'METROS: ' + _parseMeters(timetable.distance),
              ),
              Text(
                'CARBONO: ' + _parseCarbonFootprint(timetable.carbonFootprint),
              ),
              Text(
                'ZONAS: ' + timetable.zones.toString(),
              ),
              Text(
                'ORIGEN: ' + timetable.originStation.name.toString(),
              ),
              Text(
                'DESTINO: ' + timetable.destinationStation.name.toString(),
              ),
              Text(
                'TIEMPO: ' + _parseDuration(timetable.duration),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _parseMeters(int distance) {
    String result = distance.toString();

    if (distance < 1000) {
      result = result + ' m';
    } else {
      result = (distance / 1000).toStringAsFixed(2) + ' Km';
    }
    return result;
  }

  _parseCarbonFootprint(double carbonFootprint) {
    String result = '';

    if (carbonFootprint < 1) {
      result = (carbonFootprint * 1000).toStringAsFixed(0) + ' g';
    } else {
      result = (carbonFootprint.toStringAsFixed(2) + ' Kg');
    }

    return result;
  }

  _parseDuration(int duration) {
    String result = '';

    if (duration < 60) {
      result = duration.toString() + ' min';
    } else {
      int hours = 0;
      while (duration > 60) {
        duration = duration - 60;
        hours++;
      }
      result = hours.toString() + ' h ' + duration.toString() + ' min';
    }

    return result;
  }
}
