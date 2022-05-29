import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_live_schedule.dart';
import 'package:metrovalencia_reloaded/models/live_schedule.dart';

abstract class AbstractFgvLiveScheduleService {
  Future<List<LiveSchedule>> getLiveSchedules(int stationId);
}

class FgvLiveScheduleServivce implements AbstractFgvLiveScheduleService {
  @override
  Future<List<LiveSchedule>> getLiveSchedules(int stationId) async {
    var url = Environment.getFgvUrl() + 'horarios-prevision/';

    try {
      final response = await http
          .get(Uri.parse(url + stationId.toString()))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Iterable rawFgvLiveSchedules = jsonDecode(response.body);
        List<FgvLiveSchedule> fgvLiveSchedules = List<FgvLiveSchedule>.from(
          rawFgvLiveSchedules.map((model) => FgvLiveSchedule.fromJson(model))
        );
            

        List<LiveSchedule> liveSchedulesList = [];

        for (var fgvLiveSchedule in fgvLiveSchedules) {
          var trainsToCheck = fgvLiveSchedule.trains ?? [];

          for (var train in trainsToCheck) {
            liveSchedulesList.add(LiveSchedule(
              fgvLiveSchedule.lineId,
              train.destino,
              Duration(seconds: train.seconds),
              train.latitude,
              train.longitude,
              train.meters,
              train.capacity,
            ));
          }
        }

        return liveSchedulesList;
      } else {
        var jsonResponse = jsonDecode(response.body);
        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        throw PlainMessageException(errorResponse);
      }
    } on TimeoutException catch (e) {
      throw FgvServerException();
    }
  }
}
