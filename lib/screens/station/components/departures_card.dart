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
                Text(
                  tr('station.departuresSubtitle'),
                  textScaleFactor: 1.2,
                ),
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
                color: Theme.of(context).colorScheme.primary,
                size: 30.0,
              ),
              child: liveDepartures.isNotEmpty
                  ? SizedBox(
                      height: (liveDepartures.length + 1) * 50.0, // Header + rows
                      child: SingleChildScrollView(
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
                            2: FixedColumnWidth(100),
                          },
                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                          children: <TableRow>[
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    tr('station.destination'),
                                    textScaler: const TextScaler.linear(1.1),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    tr('station.departure'),
                                    textScaler: const TextScaler.linear(1.1),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    tr('station.occupancy'),
                                    textScaler: const TextScaler.linear(1.1),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            for (var liveScheduletoShow in liveDepartures)
                              TableRow(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        LineNumber(
                                          liveScheduletoShow.lineId,
                                          HexColor(liveScheduletoShow.lineColor),
                                          25,
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            liveScheduletoShow.destination,
                                            softWrap: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          liveScheduletoShow.timeToArrival.inMinutes
                                              .toString(),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'station.minute'.plural(
                                            liveScheduletoShow.timeToArrival.inMinutes,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      height: 20,
                                      child: Visibility(
                                        visible: liveScheduletoShow.capacity != null,
                                        child: LinearPercentIndicator(
                                          width: 100,
                                          lineHeight: 5,
                                          progressColor: _getCapacityColor(
                                              liveScheduletoShow.capacity ?? 0),
                                          percent: (liveScheduletoShow.capacity ?? 0) / 100,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          tr('station.noDeparturesAvaiable'),
                          textAlign: TextAlign.center,
                          textScaler: const TextScaler.linear(1.1),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCapacityColor(int capacity) {
    if (capacity > 80) return Colors.red;
    if (capacity > 50) return Colors.yellow;
    return Colors.green;
  }
}