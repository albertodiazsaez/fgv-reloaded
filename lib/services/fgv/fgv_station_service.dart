import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_line.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';
import 'package:metrovalencia_reloaded/models/line.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

import 'package:metrovalencia_reloaded/utils/constants.dart';

abstract class AbstractFgvStationService {
  Future<List<Station>> getStations();
}

class FgvStationService implements AbstractFgvStationService {
  var stationsUrl = Environment.getFgvUrl() + 'estaciones';
  var linesUrl = Environment.getFgvUrl() + 'lineas';

  @override
  Future<List<Station>> getStations() async {
    try {
      final stationsResponse = await http
          .get(Uri.parse(stationsUrl))
          .timeout(const Duration(seconds: Constants.timeoutSeconds));

      if (stationsResponse.statusCode == 200) {
        List<FgvLine> fgvLines = await _getFgvLines();

        Iterable rawStations = jsonDecode(stationsResponse.body);
        List<FgvStation> fgvStations = List<FgvStation>.from(
            rawStations.map((model) => FgvStation.fromJson(model)));
        List<Station> stations = [];

        fgvStations.forEach((fgvStation) {
          List<Line> stationLines = _mapFgvLines(fgvLines, fgvStation);

          stations.add(Station.fgvStationToStation(fgvStation, stationLines));
        });

        stations.sort((a, b) =>
            removeDiacritics(a.name).compareTo(removeDiacritics(b.name)));

        return stations;
      } else {
        var jsonResponse = jsonDecode(stationsResponse.body);
        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        throw PlainMessageException(errorResponse);
      }
    } on TimeoutException catch (e) {
      throw FgvServerException();
    } on SocketException catch (e) {
      throw FgvServerException();
    } on Exception catch (e) {
      throw FgvServerException();
    }
  }

  List<Line> _mapFgvLines(List<FgvLine> fgvLines, FgvStation fgvStation) {
    List<Line> stationLines = [];

    fgvLines.forEach((fgvLine) {
      if (fgvLine.stops
          .split(',')
          .contains(fgvStation.estacionIdFgv.toString())) {
        stationLines.add(Line(
            fgvLine.lineaIdFgv,
            fgvLine.nombreCorto,
            fgvLine.nombreLargo,
            fgvLine.tipo,
            fgvLine.color,
            fgvLine.formaId,
            fgvLine.sede));
      }
    });
    return stationLines;
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
