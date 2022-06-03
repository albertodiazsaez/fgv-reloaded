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

  @override
  Widget build(BuildContext context) {
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
                        showCursor: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: tr('timetable.selectDestinationStation'),
                        ),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(0000),
                              lastDate: DateTime(9999));
                        },
                        child: Text('FEEEECHA'),
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
}
