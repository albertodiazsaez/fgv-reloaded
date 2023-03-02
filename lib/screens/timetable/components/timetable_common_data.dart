import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/timetable.dart';

class TimetableCommonData extends StatelessWidget {
  const TimetableCommonData(this.timetable, {Key? key}) : super(key: key);

  final Timetable timetable;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    timetable.originStation.name,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: Icon(
                    Icons.arrow_forward,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    timetable.destinationStation.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(plural('timetable.zone', timetable.zones.length) +
                          ':'),
                      Text(timetable.zones),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.timer_outlined),
                      Text(_parseDuration(timetable.duration)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.straighten),
                      Text(_parseMeters(timetable.distance)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Icon(Icons.co2),
                      Text(_parseCarbonFootprint(timetable.carbonFootprint)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
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
