import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_line.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_nearby_station.dart';
import 'package:metrovalencia_reloaded/models/live_departures.dart';
import 'package:metrovalencia_reloaded/models/nearby_station.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/utils/constants.dart';

abstract class AbstractFgvNeabyStationService {
  Future<List<NearbyStation>> getNearbyStations();
}

class FgvNearbyStationService implements AbstractFgvNeabyStationService {
  var url = Environment.getFgvUrl() + 'horarios-cercanos?latitud=';
  var linesUrl = Environment.getFgvUrl() + 'lineas';

  @override
  Future<List<NearbyStation>> getNearbyStations() async {
    Position? position = await Geolocator.getCurrentPosition();
    if (position != null) {
      try {
        double latitude = position.latitude;
        double longitude = position.longitude;
        log("LATITUD: " +
            latitude.toString() +
            " LONGITUD: " +
            longitude.toString());
        final response = await http
            .get(Uri.parse(url +
                latitude.toString() +
                '&longitud=' +
                longitude.toString()))
            .timeout(const Duration(seconds: Constants.timeoutSeconds));

        if (response.statusCode == 200) {
          Iterable rawFgvNearbyStations = jsonDecode(response.body);
          List<FgvNearbyStation> fgvNearbyStations =
              List<FgvNearbyStation>.from(
            rawFgvNearbyStations.map(
              (rawJson) => FgvNearbyStation.fromJson(
                rawJson,
              ),
            ),
          );

          List<NearbyStation> nearbyStationsList = [];
          List<FgvLine> fgvLines = await _getFgvLines();

          for (FgvNearbyStation fgvNearbyStation in fgvNearbyStations) {
            List<LiveDepartures> liveDeparturesList = [];

            for (var fgvLiveSchedule in fgvNearbyStation.previsiones) {
              var trainsToCheck = fgvLiveSchedule.trains ?? [];

              for (var train in trainsToCheck) {
                liveDeparturesList.add(LiveDepartures(
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
            nearbyStationsList.add(NearbyStation(
                Station.fgvStationToStation(fgvNearbyStation.estacion),
                liveDeparturesList));
          }
          return nearbyStationsList;
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
    } else {
      return [];
    }
  }

  // TODO: Enviar a clase genérica, copiado de fgv_live_schedule_service.dart
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
