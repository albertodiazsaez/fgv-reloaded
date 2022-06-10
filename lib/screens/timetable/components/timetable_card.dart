import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      child: Card(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Text(
                        timetable.originStation.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Expanded(
                      child: Icon(
                        Icons.arrow_forward,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        timetable.destinationStation.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              TimetableCommonData(timetable),
              DefaultTabController(
                length: timetable.transfers.length,
                child: Column(
                  children: [
                    // TabBar(
                    //   labelColor: Theme.of(context).colorScheme.primary,
                    //   indicatorColor: Theme.of(context).colorScheme.primary,
                    //   tabs: [
                    //     for (var i = 1;
                    //         i <= timetable.transfers.length;
                    //         i++) ...{
                    //       Tab(
                    //         child: Text('Viaje ' + i.toString()),
                    //       )
                    //     }
                    //   ],
                    // ),
                    // SizedBox(
                    //   child: TabBarView(
                    //     children: [
                    //       for (var transfer in timetable.transfers) ...{
                    //         TimetableTransfer(timetable.transfers[0]),
                    //       }
                    //     ],
                    //   ),
                    // ),
                    for (var transfer in timetable.transfers) ...{
                      TimetableTransfer(transfer)
                    }
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
