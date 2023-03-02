import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/models/timetable.dart';
import 'package:metrovalencia_reloaded/screens/timetable/components/timetable_card.dart';
import 'package:metrovalencia_reloaded/screens/timetable/components/timetable_form_card.dart';
import 'package:metrovalencia_reloaded/screens/timetable/pages/select-station-page/select_station_page.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_timetable_service.dart';
import 'package:metrovalencia_reloaded/services/service_locator.dart';
import 'package:metrovalencia_reloaded/utils/loader_utils.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key, this.inputOriginStation}) : super(key: key);

  final Station? inputOriginStation;

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

AbstractFgvTimetableService timetableService =
    getIt<AbstractFgvTimetableService>();

class _TimetableScreenState extends State<TimetableScreen>
    with AutomaticKeepAliveClientMixin<TimetableScreen> {
  @override
  bool get wantKeepAlive => true;

  Timetable? currentTimetable;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          TimetableFormCard(
            onCheckTimetable: _onCheckTimetable,
            inputOriginStation: widget.inputOriginStation,
          ),
          if (currentTimetable != null) ...[
            TimetableCard(currentTimetable!),
          ],
        ],
      ),
    );
  }

  _onCheckTimetable(
      int originStationId, int destinationStationId, DateTime date) {
    LoaderUtils.setLoader();

    timetableService
        .getCompleteTimetable(originStationId, destinationStationId, date)
        .then(
          (value) => {
            LoaderUtils.dismissLoader(),
            setState(
              () {
                currentTimetable = value;
              },
            )
          },
        )
        .catchError((e) {
      setState(() {
        currentTimetable = null;
      });
      LoaderUtils.dismissLoader();
      SnackbarUtils.textSnackbar(context, e.toString());
    });
  }
}

class RouteSelectOriginStation extends StatelessWidget {
  const RouteSelectOriginStation(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const SelectStationPage(),
    );
  }
}
