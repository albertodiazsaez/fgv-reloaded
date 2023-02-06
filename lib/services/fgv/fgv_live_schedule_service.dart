import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_line.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_live_schedule.dart';
import 'package:metrovalencia_reloaded/models/live_departures.dart';
import 'package:metrovalencia_reloaded/utils/constants.dart';

abstract class AbstractFgvLiveScheduleService {
  Future<List<LiveDepartures>> getLiveSchedules(int stationId);
}

class FgvLiveScheduleServivce implements AbstractFgvLiveScheduleService {
  var url = Environment.getFgvUrl() + 'horarios-prevision/';
  var linesUrl = Environment.getFgvUrl() + 'lineas';
  @override
  Future<List<LiveDepartures>> getLiveSchedules(int stationId) async {
    try {
      final response = await http
          .get(Uri.parse(url + stationId.toString()))
          .timeout(const Duration(seconds: Constants.timeoutSeconds));

      if (response.statusCode == 200) {
        Iterable rawFgvLiveSchedules = jsonDecode(response.body);
        List<FgvLiveSchedule> fgvLiveSchedules = List<FgvLiveSchedule>.from(
            rawFgvLiveSchedules
                .map((model) => FgvLiveSchedule.fromJson(model)));

        List<LiveDepartures> liveSchedulesList = [];
        List<FgvLine> fgvLines = await _getFgvLines();

        for (var fgvLiveSchedule in fgvLiveSchedules) {
          var trainsToCheck = fgvLiveSchedule.trains ?? [];

          for (var train in trainsToCheck) {
            liveSchedulesList.add(LiveDepartures(
              fgvLiveSchedule.lineId,
              fgvLines
                  .where((element) => element.lineaIdFgv == train.lineId)
                  .first
                  .color,
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
    } on Exception catch (e) {
      throw FgvServerException();
    }
  }

  _getFgvLines() async {
    try {
      final linesResponse = await http
          .get(Uri.parse(linesUrl))
          .timeout(const Duration(seconds: Constants.timeoutSeconds));

      if (linesResponse.statusCode == 200) {
        Iterable rawLines = jsonDecode(linesResponse.body);
        List<FgvLine> fgvLines = List<FgvLine>.from(
            rawLines.map((model) => FgvLine.fromJson(model)));
        return fgvLines;
      } else {
        var jsonResponse = jsonDecode(linesResponse.body);
        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        throw PlainMessageException(errorResponse);
      }
    } on TimeoutException catch (e) {
      throw FgvServerException();
    }
  }
}
