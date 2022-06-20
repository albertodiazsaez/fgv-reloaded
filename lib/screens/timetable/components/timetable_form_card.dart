import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/timetable/timetable_screen.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class TimetableFormCard extends StatefulWidget {
  const TimetableFormCard(
      {Key? key, required this.onCheckTimetable, this.inputOriginStation})
      : super(key: key);

  @override
  State<TimetableFormCard> createState() => _TimetableFormCardState();

  final Station? inputOriginStation;

  final Function(int originStationId, int destinationStationId, DateTime date)
      onCheckTimetable;
}

final _timetableForm = GlobalKey<FormState>();

class _TimetableFormCardState extends State<TimetableFormCard> {
  var dateController = TextEditingController();
  var originStationController = TextEditingController();
  var destinationStationController = TextEditingController();

  int? originStationId;
  int? destinationStationId;
  DateTime? date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _setInputOriginStation();

    dateController.text = _parseDate(date);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      width: double.infinity,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Form(
            key: _timetableForm,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(5),
                            child: TextFormField(
                              onTap: () => navigateToSelectionScreen(
                                context,
                                tr('timetable.originStation'),
                              ).first.then((value) => _setOriginStation(
                                  value.first.id, value.first.name)),
                              controller: originStationController,
                              showCursor: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                label: Text(tr('timetable.originStation')),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(5),
                            child: TextFormField(
                              onTap: () => navigateToSelectionScreen(
                                context,
                                tr('timetable.destinationStation'),
                              ).first.then((value) => _setDestinationStation(
                                  value.first.id, value.first.name)),
                              controller: destinationStationController,
                              showCursor: false,
                              readOnly: true,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                label: Text(tr('timetable.destinationStation')),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: IconButton(
                        splashRadius: 25,
                        onPressed: (() {
                          _reverseStations();
                        }),
                        iconSize: 30,
                        icon: const Icon(
                          Icons.swap_vert,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => {
                          date = date?.subtract(
                            Duration(days: 1),
                          ),
                          dateController.text = _parseDate(date)
                        },
                        icon: Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: dateController,
                            onTap: () => {
                              showDatePicker(
                                context: context,
                                initialDate: date!,
                                firstDate: DateTime(0000),
                                lastDate: DateTime(9999),
                              ).then(
                                (value) => {
                                  date = value!,
                                  dateController.text = _parseDate(date),
                                },
                              ),
                            },
                            showCursor: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: tr('timetable.selectDate'),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => {
                          date = date?.add(
                            Duration(days: 1),
                          ),
                          dateController.text = _parseDate(date)
                        },
                        icon: Icon(Icons.chevron_right),
                      ),
                      ElevatedButton(
                        onPressed: formIsInvalid()
                            ? null
                            : () {
                                _checkTimetable();
                              },
                        child: Text(tr('station.lookUp')),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setInputOriginStation() {
    if (widget.inputOriginStation != null && originStationId == null) {
      _setOriginStation(
          widget.inputOriginStation!.id, widget.inputOriginStation!.name);
    }
  }

  String _parseDate(DateTime? value) {
    String dateParsed =
        DateFormat('E dd-MM-yyyy', context.locale.toString()).format(value!);
    return dateParsed[0].toUpperCase() + dateParsed.substring(1);
  }

  void _reverseStations() {
    setState(() {
      int? originStationIdTemp = originStationId;
      String originStationTemp = originStationController.text;
      _setOriginStation(
          destinationStationId ?? 0, destinationStationController.text);
      _setDestinationStation(originStationIdTemp ?? 0, originStationTemp);
    });
  }

  void _setOriginStation(int id, String name) {
    setState(() {
      originStationId = id;
      originStationController.text = name;
    });
    FocusScope.of(context).unfocus();
  }

  void _setDestinationStation(int id, String name) {
    setState(() {
      destinationStationId = id;
      destinationStationController.text = name;
    });
    FocusScope.of(context).unfocus();
  }

  bool formIsInvalid() {
    return destinationStationController.text != '' &&
            originStationController.text != ''
        ? false
        : true;
  }

  void _checkTimetable() {
    if (originStationId != destinationStationId) {
      widget.onCheckTimetable(
        originStationId!,
        destinationStationId!,
        date!,
      );
    } else {
      SnackbarUtils.textSnackbar(
          context, tr('timetable.chooseDifferentStations'));
    }
  }

  Set<Future<Set<Station>>> navigateToSelectionScreen(
      BuildContext context, String title) {
    return {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (
            context,
            animation1,
            animation2,
          ) =>
              RouteSelectOriginStation(title),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      ).then(
        (value) => {value as Station},
      )
    };
  }
}
