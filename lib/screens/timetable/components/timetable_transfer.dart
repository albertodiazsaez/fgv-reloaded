import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/timetable.dart';

class TimetableTransfer extends StatelessWidget {
  const TimetableTransfer(this.transfer, {Key? key}) : super(key: key);

  final Transfer transfer;

  @override
  Widget build(BuildContext context) {
    int tableRows = _getDeparturesCount(transfer.departures);

    return Card(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    transfer.originStation.name,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: Icon(
                    Icons.route,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    transfer.destinationStation.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Trenes con destino:',
                    textAlign: TextAlign.center,
                  ),
                ),
                for (var destination in transfer.possibleDestinations) ...{
                  Expanded(
                      child: Text(
                    destination,
                    textAlign: TextAlign.center,
                  ))
                }
              ],
            ),
          ),
          Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  for (var hour in transfer.departures.keys)
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          hour.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
                rows: [
                  for (var i = 0; i < tableRows; i++) ...{
                    DataRow(
                      cells: [
                        for (var departure in transfer.departures.values) ...{
                          DataCell(_getTime(departure))
                        }
                      ],
                    ),
                  }
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }

  _getTime(List<String> departure) {
    if (departure.isNotEmpty) {
      return Center(
          child: Text(
        departure.removeAt(0),
        textAlign: TextAlign.center,
      ));
    } else {
      return const Center(
        child: Text(
          '-',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  int _getDeparturesCount(Map<int, List<String>> departures) {
    int count = 0;

    departures.forEach((key, value) {
      if (count < value.length) {
        count = value.length;
      }
    });
    return count;
  }
}
