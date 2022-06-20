import 'package:flutter/material.dart';

import 'package:metrovalencia_reloaded/models/timetable.dart';
import 'package:metrovalencia_reloaded/screens/timetable/components/timetable_common_data.dart';
import 'package:metrovalencia_reloaded/screens/timetable/components/timetable_transfer.dart';

class TimetableCard extends StatelessWidget {
  const TimetableCard(this.timetable, {Key? key}) : super(key: key);

  final Timetable timetable;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            TimetableCommonData(timetable),
            DefaultTabController(
              length: timetable.transfers.length,
              child: Column(
                children: [
                  for (var transfer in timetable.transfers) ...{
                    TimetableTransfer(transfer)
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
