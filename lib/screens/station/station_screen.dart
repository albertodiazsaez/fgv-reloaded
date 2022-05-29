import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  bool arrivalsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadLiveSchedules();
  }

  void loadLiveSchedules() {
    try {
      setState(() {
        arrivalsLoaded = false;
        liveScheduleService.getLiveSchedules(widget.station.id).then(
              (liveSchedules) => {
                setState(
                  () => {
                    liveScheduleList = liveSchedules,
                    arrivalsLoaded = true,
                  },
                )
              },
            );
      });
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
        // Arrivals Card
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(tr('station.arrivalsSubtitle'), textScaleFactor: 1.2),
                    IconButton(
                      splashRadius: 15,
                      onPressed: loadLiveSchedules,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: arrivalsLoaded,
                  replacement: const SpinKitFadingCircle(
                      // TODO: Usar color del tema
                      color: Colors.red),
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
                              textScaleFactor: 1.1,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              tr('station.departure'),
                              textScaleFactor: 1.1,
                            ),
                          ),
                          Container(
                            child: Text(
                              tr('station.occupancy'),
                              textScaleFactor: 1.1,
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
                                  liveScheduletoShow.timeToArrival.inMinutes
                                      .toString(),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 3),
                                    child: Text('station.minute'.plural(
                                        liveScheduletoShow
                                            .timeToArrival.inMinutes))),
                              ],
                            ),
                          ),
                          Container(
                            child: Visibility(
                                visible: liveScheduletoShow.capacity != null,
                                child: LinearProgressIndicator(
                                  value: double.parse(
                                          liveScheduletoShow.capacity != null
                                              ? liveScheduletoShow.capacity
                                                  .toString()
                                              : '0') /
                                      100,
                                )),
                          ),
                        ])
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
