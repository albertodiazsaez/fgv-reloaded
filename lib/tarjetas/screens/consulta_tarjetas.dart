import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:transport_info_valencia/tarjetas/models/datos_tarjeta.dart';
import 'package:transport_info_valencia/tarjetas/models/tarjeta_metrovalencia.dart';

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
        'https://www.fgv.es/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));
    //'http://192.168.98.220:3000/ap18/api/public/es/api/v1/V/tarjetas-transporte/$numeroTarjeta'));

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
                  inputFormatters: [TextInputMask(mask: '9999 9999 9999')],
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
                          inputTarjetaController.text.replaceAll(' ', '')),
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
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).dividerColor))),
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text('Número Tarjeta:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(' ${maskTarjeta(iTarjeta.numeroTarjeta)}')
                              ],
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          child: Row(
                            children: [
                              const Text('Título:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(' ${iTarjeta.titulo}')
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          child: Row(
                            children: [
                              const Text('Clase:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(' ${iTarjeta.clase}')
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          child: Row(
                            children: [
                              const Text('Zona:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(' ${iTarjeta.zona}')
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          child: Row(
                            children: [
                              const Text('Saldo:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                ' ${iTarjeta.saldo}',
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String maskTarjeta(String numeroTarjeta) {
    return MagicMask.buildMask('9999 9999 9999').getMaskedString(numeroTarjeta);
  }
}
