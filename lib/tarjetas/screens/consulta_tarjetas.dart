import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:transport_info_valencia/tarjetas/models/datos_tarjeta.dart';

import 'dart:convert';

import 'package:transport_info_valencia/tarjetas/models/tarjeta_metrovalencia.dart';

class ConsultaTarjetas extends StatefulWidget {
  const ConsultaTarjetas({Key? key}) : super(key: key);

  @override
  State<ConsultaTarjetas> createState() => _ConsultaTarjetasState();
}

class _ConsultaTarjetasState extends State<ConsultaTarjetas> {
  final GlobalKey<FormState> _consultaTarjetaFormKey = GlobalKey<FormState>();
  final inputTarjetaController = TextEditingController();

  final inputTarjetaMask = MaskTextInputFormatter(
      mask: '#### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  Map tarjetasConsultadas = <int, DatosTarjeta>{};

  void obtenerDatosTarjetaMetrovalencia(String numeroTarjeta) async {
    print("NUMERO TARJETA $numeroTarjeta");
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

    final response = await http.get(Uri.parse(
        //'https://www.fgv.es/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));
        'http://192.168.98.220:3000/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));

    if (response.statusCode == 200) {
      print("OKEY " + response.body.toString());

      var tarjetaRecibida = ResultadoConsultaTarjetaMetrovalencia.fromJson(
              jsonDecode(response.body))
          .resultado;
      setState(() {
        tarjetasConsultadas[int.parse(numeroTarjeta)] = DatosTarjeta(
            numeroTarjeta: numeroTarjeta,
            titulo: tarjetaRecibida?.titulo,
            zona: tarjetaRecibida?.zona,
            clase: tarjetaRecibida?.clase,
            saldo: tarjetaRecibida?.saldo);
      });
      EasyLoading.dismiss();
    } else {
      print("ERROR " + response.body.toString());
      EasyLoading.dismiss();
      throw Exception();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputTarjetaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _consultaTarjetaFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  inputFormatters: [inputTarjetaMask],
                  controller: inputTarjetaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Introduce el número de la tarjeta'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor introduzca un número válido';
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () => {
                      obtenerDatosTarjetaMetrovalencia(
                          inputTarjetaMask.getUnmaskedText()),
                    },
                    child: const Text('Comprobar Tarjeta'),
                  ),
                )
              ],
            )),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: tarjetasConsultadas.keys.length,
            itemBuilder: (context, index) {
              DatosTarjeta iTarjeta = tarjetasConsultadas[tarjetasConsultadas
                  .keys
                  .toList()
                  .reversed
                  .toList()
                  .elementAt(index)];

              return SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Número Tarjeta: ${iTarjeta.numeroTarjeta}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Título: ${iTarjeta.titulo}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Clase: ${iTarjeta.clase}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Zona: ${iTarjeta.zona}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Saldo: ${iTarjeta.saldo}',
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
