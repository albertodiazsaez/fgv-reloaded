import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_online_timetable.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/models/timetable.dart';
import 'package:metrovalencia_reloaded/utils/constants.dart';

abstract class AbstractFgvTimetableService {
  static const String nightScheduleIndicator = "N";
  static const String dayScheduleIndicator = "D";

  Future<Timetable> getTimetable(
    int originStationId,
    int destinationStationId,
    DateTime date,
  );

  Future<Timetable> getCompleteTimetable(
    int originStationId,
    int destinationStationId,
    DateTime date,
  );
}

class FgvTimetableService implements AbstractFgvTimetableService {
  var url = Environment.getFgvUrl() + 'horarios-online';

  @override
  Future<Timetable> getTimetable(
    int originStationId,
    int destinationStationId,
    DateTime date,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: <String, String>{
          'estacion_origen_id': originStationId.toString(),
          'estacion_destino_id': destinationStationId.toString(),
          'fecha': DateFormat('dd/MM/yyyy').format(date)
        },
      ).timeout(const Duration(seconds: Constants.timeoutSeconds));

      if (response.statusCode == 200) {
        var resultTimetableFgv =
            FgvOnlineTimetable.fromJson(jsonDecode(response.body)).resultado;

        List<Transfer> transfers = [];

        resultTimetableFgv!.transbordos?.forEach((fgvTransfer) {
          Map<String, List<String>> departures = {};

          fgvTransfer.horas?.forEach((key, value) {
            departures.putIfAbsent(
                AbstractFgvTimetableService.dayScheduleIndicator + key,
                () => value);
          });

          transfers.add(Transfer(
            Station.fgvStationToStation(fgvTransfer.estacionOrigenTransbordo!),
            Station.fgvStationToStation(fgvTransfer.estacionDestinoTransbordo!),
            fgvTransfer.destinos!,
            departures,
          ));
        });

        return Timetable(
            Station.fgvStationToStation(resultTimetableFgv.estacionOrigen!),
            Station.fgvStationToStation(resultTimetableFgv.estacionDestino!),
            resultTimetableFgv.tarifas ?? '',
            resultTimetableFgv.huellaDeCarbono!,
            resultTimetableFgv.duracionMinutos!,
            resultTimetableFgv.distancia!,
            transfers);
      } else {
        var jsonResponse = jsonDecode(response.body);
        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        throw PlainMessageException(errorResponse);
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      throw FgvServerException();
    }
  }

  @override
  Future<Timetable> getCompleteTimetable(
      int originStationId, int destinationStationId, DateTime date) async {
    late Timetable sameDayTimetable;

    await getTimetable(originStationId, destinationStationId, date)
        .then((timetable) => (sameDayTimetable = timetable))
        .timeout(const Duration(seconds: Constants.timeoutSeconds));

    await getTimetable(
      originStationId,
      destinationStationId,
      date.add(
        const Duration(
          days: 1,
        ),
      ),
    )
        .then(
          (nextDayTimetable) => {
            _setNightTimetable(
              sameDayTimetable,
              nextDayTimetable,
            ),
          },
        )
        .timeout(const Duration(seconds: Constants.timeoutSeconds));

    return sameDayTimetable;
  }

  void _setNightTimetable(
      Timetable sameDayTimetable, Timetable nextDayTimetable) {
    for (var sameDayTransfer in sameDayTimetable.transfers) {
      int transferIndex = sameDayTimetable.transfers.indexOf(sameDayTransfer);

      nextDayTimetable.transfers[transferIndex].departures
          .forEach((key, value) {
        if (int.parse(key.substring(1)) < 4) {
          sameDayTransfer.departures.putIfAbsent(
              AbstractFgvTimetableService.nightScheduleIndicator +
                  key.substring(1),
              () => value);
        }
      });
    }
  }
}
