import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/fgv_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/fgv/fgv_station.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:http/http.dart' as http;

abstract class AbstractFgvStationService {
  Future<List<Station>> getStations();
}

class FgvStationService implements AbstractFgvStationService {
  var url = Environment.getFgvUrl() + 'estaciones';

  @override
  Future<List<Station>> getStations() async {
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Iterable rawStations = jsonDecode(response.body);
        List<FgvStation> fgvStations = List<FgvStation>.from(
            rawStations.map((model) => FgvStation.fromJson(model)));
        List<Station> stations = [];

        fgvStations.forEach((fgvStation) {

          bool transbordo = fgvStation.transbordo == 1;

          stations.add(Station(
              fgvStation.estacionIdFgv,
              fgvStation.nombre,
              transbordo,
              fgvStation.latitud,
              fgvStation.longitud,
              fgvStation.sede,
              fgvStation.direccion));
        });

        return stations;
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
