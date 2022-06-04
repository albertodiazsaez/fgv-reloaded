import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({Key? key}) : super(key: key);

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final _timetableForm = GlobalKey<FormState>();

  var dateController = TextEditingController();
  var originStationController = TextEditingController();
  var destinationStationController = TextEditingController();

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    this.dateController.text = _parseDate(currentDate);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          child: Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: originStationController,
                        showCursor: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: tr('timetable.selectOriginStation'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: TextFormField(
                        controller: destinationStationController,
                        showCursor: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: tr('timetable.selectDestinationStation'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => {
                              currentDate = currentDate.subtract(
                                Duration(days: 1),
                              ),
                              dateController.text = _parseDate(currentDate)
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
                                    initialDate: currentDate,
                                    firstDate: DateTime(0000),
                                    lastDate: DateTime(9999),
                                  ).then(
                                    (value) => {
                                      currentDate = value!,
                                      dateController.text =
                                          _parseDate(currentDate),
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
                              currentDate = currentDate.add(
                                Duration(days: 1),
                              ),
                              dateController.text = _parseDate(currentDate)
                            },
                            icon: Icon(Icons.chevron_right),
                          ),
                          ElevatedButton(
                            onPressed: () {},
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
        )
      ],
    );
  }

  String _parseDate(DateTime? value) {
    String dateParsed =
        DateFormat('E dd-MM-yyyy', context.locale.toString()).format(value!);
    return dateParsed[0].toUpperCase() + dateParsed.substring(1);
  }
}
