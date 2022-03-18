import 'dart:developer';

import 'package:flutter/material.dart';
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
    final response = await http.get(Uri.parse(
        'https://www.fgv.es/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));
//        'http://192.168.98.220:3000/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));

    if (response.statusCode == 200) {
      print("OKEY " + response.body.toString());

      var tarjetaRecibida = ResultadoConsultaTarjetaMetrovalencia.fromJson(
              jsonDecode(response.body))
          .resultado;
      setState(() {
        tarjetasConsultadas[int.parse(numeroTarjeta)] = DatosTarjeta(
            numeroTarjeta: int.parse(numeroTarjeta),
            titulo: tarjetaRecibida?.titulo,
            zona: tarjetaRecibida?.zona,
            clase: tarjetaRecibida?.clase,
            saldo: tarjetaRecibida?.saldo);
      });
    } else {
      print("ERROR " + response.body.toString());
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
              int key = tarjetasConsultadas.keys
                  .toList()
                  .reversed
                  .toList()
                  .elementAt(index);
              print('KEY: $key LENGHT: ${tarjetasConsultadas.keys.length}');
              return SizedBox(
                width: double.infinity,
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Número Tarjeta: ${tarjetasConsultadas[key].numeroTarjeta}',
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Título: ${tarjetasConsultadas[key].titulo}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Clase: ${tarjetasConsultadas[key].clase}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Zona: ${tarjetasConsultadas[key].zona}',
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Saldo: ${tarjetasConsultadas[key].saldo}',
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
