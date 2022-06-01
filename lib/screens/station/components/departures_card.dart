import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/live_departures.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DeparturesCard extends StatelessWidget {
  const DeparturesCard({
    Key? key,
    required this.showDepartures,
    required this.liveDepartures,
    required this.onDeparturesRefresh,
  }) : super(key: key);

  final Function() onDeparturesRefresh;
  final bool showDepartures;
  final List<LiveDepartures> liveDepartures;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(tr('station.departuresSubtitle'), textScaleFactor: 1.2),
                IconButton(
                  splashRadius: 15,
                  onPressed: onDeparturesRefresh,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 20,
                  ),
                )
              ],
            ),
            Visibility(
              visible: showDepartures,
              replacement: SpinKitFadingCircle(
                  color: Theme.of(context).colorScheme.primary),
              child: Table(
                border: const TableBorder(
                  horizontalInside: BorderSide(
                    style: BorderStyle.solid,
                    width: 0.5,
                    color: Colors.grey,
                  ),
                ),
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(),
                  1: IntrinsicColumnWidth(),
                  2: IntrinsicColumnWidth(),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: <TableRow>[
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: Text(
                          tr('station.destination'),
                          textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: Text(
                          tr('station.departure'),
                          textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: Text(
                          tr('station.occupancy'),
                          textScaleFactor: 1.1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  for (var liveScheduletoShow in liveDepartures)
                    TableRow(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          margin: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            children: [
                              LineNumber(liveScheduletoShow.lineId,
                                  HexColor(liveScheduletoShow.lineColor), 25),
                              Flexible(
                                child: Text(
                                  liveScheduletoShow.destination,
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                liveScheduletoShow.timeToArrival.inMinutes
                                    .toString(),
                                //   textAlign: TextAlign.end,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 3),
                                child: Text(
                                  'station.minute'.plural(
                                    liveScheduletoShow.timeToArrival.inMinutes,
                                  ),
                                  // textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Visibility(
                            visible: liveScheduletoShow.capacity != null,
                            child: LinearPercentIndicator(
                              progressColor: _getCapacityColor(
                                  liveScheduletoShow.capacity ?? 0),
                              percent: double.parse(
                                      liveScheduletoShow.capacity != null
                                          ? liveScheduletoShow.capacity
                                              .toString()
                                          : '0') /
                                  100,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCapacityColor(int capacity) {
    var result = Colors.green;

    if (capacity > 50) {
      result = Colors.yellow;
    } else if (capacity > 80) {
      result = Colors.red;
    }

    return result;
  }
}
