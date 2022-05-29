import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/live_schedule.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_live_schedule_service.dart';
import 'package:metrovalencia_reloaded/services/service_locator.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class StationScreen extends StatefulWidget {
  const StationScreen(this.station, {Key? key}) : super(key: key);

  @override
  State<StationScreen> createState() => _StationScreenState();

  final Station station;
}

class _StationScreenState extends State<StationScreen> {
  AbstractFgvLiveScheduleService liveScheduleService =
      getIt<AbstractFgvLiveScheduleService>();
  List<LiveSchedule> liveScheduleList = [];
  @override
  void initState() {
    super.initState();
    try {
      liveScheduleService.getLiveSchedules(widget.station.id).then(
          (liveSchedules) =>
              setState((() => liveScheduleList = liveSchedules)));
    } catch (e) {
      SnackbarUtils.textSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    ('station.line').plural(widget.station.lines!.length),
                    textScaleFactor: 1.2,
                  ),
                ),
                Row(
                  children: <Widget>[
                    for (var line in widget.station.lines!)
                      LineNumber(line.id, HexColor(line.color), 25)
                  ],
                )
              ],
            ),
          ),
        ),
        Card(
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
                  tr('station.adress'),
                  textScaleFactor: 1.2,
                ),
                Text(
                  widget.station.adress,
                ),
              ],
            ),
          ),
        ),
        Card(
            child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(),
              1: IntrinsicColumnWidth(),
              2: IntrinsicColumnWidth()
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: <TableRow>[
              TableRow(
                children: [
                  Container(
                    child: Text(
                      tr('station.destination'),
                      textScaleFactor: 1.2,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      tr('station.arrival'),
                      textScaleFactor: 1.2,
                    ),
                  ),
                  Container(
                    child: Text(
                      tr('station.occupancy'),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ],
              ),
              for (var liveScheduletoShow in liveScheduleList)
                TableRow(children: <Widget>[
                  Container(
                    child: Text(liveScheduletoShow.destination),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          liveScheduletoShow.timeToArrival.inMinutes.toString(),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 3),
                            child: Text('station.minute'.plural(
                                liveScheduletoShow.timeToArrival.inMinutes))),
                      ],
                    ),
                  ),
                  Container(
                    child: Visibility(
                        visible: liveScheduletoShow.capacity != null,
                        child: LinearProgressIndicator(
                          value: double.parse(
                                  liveScheduletoShow.capacity != null
                                      ? liveScheduletoShow.capacity.toString()
                                      : '0') /
                              100,
                        )),
                  ),
                ])
            ],
          ),
        ))
      ],
    );
  }
}
