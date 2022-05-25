import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:metrovalencia_reloaded/environments/environment.dart';
import 'package:metrovalencia_reloaded/exceptions/metrovalencia_server_exception.dart';
import 'package:metrovalencia_reloaded/exceptions/plain_message_exception.dart';
import 'package:metrovalencia_reloaded/models/metrovalencia/metrovalencia_transport_card.dart';
import 'package:metrovalencia_reloaded/models/transport_card_data.dart';
import 'package:http/http.dart' as http;

abstract class AbstractMetrovalenciaTransportCardService {
  Future<TransportCard> getTransportCard(String transportCardNumber);
}

class MetrovalenciaTransportCardService
    implements AbstractMetrovalenciaTransportCardService {

var url = Environment.getFgvUrl()+'tarjetas-transporte/';

  @override
  Future<TransportCard> getTransportCard(String transportCardNumber) async {
    try {
      final response = await http
          .get(Uri.parse(url+transportCardNumber))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        var resultTransportCard =
            MetrovalenciaTransportCard.fromJson(jsonDecode(response.body))
                .resultado;

        return TransportCard(
            cardNumber: transportCardNumber,
            title: resultTransportCard?.titulo,
            zone: resultTransportCard?.zona,
            cardClass: resultTransportCard?.clase,
            balance: resultTransportCard?.saldo,
            validityDate: resultTransportCard?.nuevaValidez == null
                ? null
                : DateFormat('dd/MM/yyyy')
                    .parse(resultTransportCard?.nuevaValidez));
      } else {
        var jsonResponse = jsonDecode(response.body);
        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        throw PlainMessageException(errorResponse);
      }
    } on TimeoutException catch (e) {
      log(e.toString());
      throw MetrovalenciaServerException();
    }
  }

//         dismissLoader();
//       } else {
//         dismissLoader();

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorResponse),
//             action: SnackBarAction(
//               label: 'Action',
//               onPressed: () {
//                 // Code to execute.
//               },
//             ),
//           ),
//         );

//         throw Exception();
//       }
//     } on TimeoutException catch (e) {
//       dismissLoader();

//
//     }
// }

}
