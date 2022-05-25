import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:metrovalencia_reloaded/tarjetas/models/transport_card_data.dart';
import 'package:metrovalencia_reloaded/tarjetas/models/metrovalencia/metrovalencia_transport_card.dart';
import 'package:metrovalencia_reloaded/tarjetas/screens/transportCards/components/tarjeta_card.dart';

class ConsultaTarjetas extends StatefulWidget {
  const ConsultaTarjetas({Key? key}) : super(key: key);

  @override
  State<ConsultaTarjetas> createState() => _ConsultaTarjetasState();
}

class _ConsultaTarjetasState extends State<ConsultaTarjetas> {
  final GlobalKey<FormState> _consultaTarjetaFormKey = GlobalKey<FormState>();
  final inputTarjetaController = TextEditingController();

  // final inputTarjetaMask = MaskTextInputFormatter(
  //     mask: '#### #### ####',
  //     filter: {"#": RegExp(r'[0-9]')},
  //     type: MaskAutoCompletionType.lazy);

  Map tarjetasConsultadas = <int, TransportCard>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Form(
                key: _consultaTarjetaFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              obtenerDatosTarjetaMetrovalencia(
                                  inputTarjetaController.text);
                            },
                            textInputAction: TextInputAction.go,
                            inputFormatters: [
                              TextInputMask(mask: tr('transportCards.cardNumberMask'))
                            ],
                            controller: inputTarjetaController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: tr('transportCards.typeCardNumber')),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () => {
                              inputTarjetaController.text = '',
                            },
                            child: Text(tr('delete')),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () => {
                              obtenerDatosTarjetaMetrovalencia(
                                  inputTarjetaController.text),
                            },
                            child: Text(tr('transportCards.checkCard')),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tarjetasConsultadas.keys.length,
                itemBuilder: (context, index) {
                  TransportCard iTarjeta = tarjetasConsultadas[
                      tarjetasConsultadas.keys
                          .toList()
                          .reversed
                          .toList()
                          .elementAt(index)];

                  return TarjetaCard(tarjeta: iTarjeta);
                },
              ),
            ),
          ],
        ));
  }

  void obtenerDatosTarjetaMetrovalencia(String numeroTarjeta) async {
    numeroTarjeta = numeroTarjeta.replaceAll(' ', '');

    //Quitamos el foco del teclado.
    FocusManager.instance.primaryFocus?.unfocus();
    setLoader();

    try {
      final response = await http
          .get(Uri.parse(
              'https://www.fgv.es/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'))
          .timeout(const Duration(seconds: 10));
      //'http://192.168.98.220:3000/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));

      if (response.statusCode == 200) {
        var tarjetaRecibida = MetrovalenciaTransportCard.fromJson(
                jsonDecode(response.body))
            .resultado;

        setState(() {
          tarjetasConsultadas[int.parse(numeroTarjeta)] = TransportCard(
              cardNumber: numeroTarjeta,
              title: tarjetaRecibida?.titulo,
              zone: tarjetaRecibida?.zona,
              cardClass: tarjetaRecibida?.clase,
              balance: tarjetaRecibida?.saldo,
              validityDate: tarjetaRecibida?.nuevaValidez == null
                  ? null
                  : DateFormat('dd/MM/yyyy')
                      .parse(tarjetaRecibida?.nuevaValidez));
        });

        dismissLoader();
      } else {
        dismissLoader();

        var jsonResponse = jsonDecode(response.body);

        var errorResponse =
            jsonResponse['resultado'] ?? tr('errors.unknownError');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorResponse),
            action: SnackBarAction(
              label: 'Action',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );

        throw Exception();
      }
    } on TimeoutException catch (e) {
      dismissLoader();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tr('errors.metrovalenciaError')),
          action: SnackBarAction(
            label: 'Action',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    }
  }

  void dismissLoader() {
    EasyLoading.dismiss();
  }

  void setLoader() {
    EasyLoading el = EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskType = EasyLoadingMaskType.black
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
    EasyLoading.show();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputTarjetaController.dispose();
    super.dispose();
  }
}
