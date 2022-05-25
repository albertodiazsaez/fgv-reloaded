import 'package:easy_localization/easy_localization.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';

import 'package:metrovalencia_reloaded/models/transport_card_data.dart';
import 'package:metrovalencia_reloaded/screens/transport-cards/components/transport_card_card.dart';
import 'package:metrovalencia_reloaded/services/fgv/service_locator.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_transport_card_service.dart';
import 'package:metrovalencia_reloaded/utils/loader_utils.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class CheckTransportCards extends StatefulWidget {
  const CheckTransportCards({Key? key}) : super(key: key);

  @override
  State<CheckTransportCards> createState() => _CheckTransportCardsState();
}

class _CheckTransportCardsState extends State<CheckTransportCards> {
  final GlobalKey<FormState> _consultaTarjetaFormKey = GlobalKey<FormState>();
  final inputTarjetaController = TextEditingController();

  AbstractFgvTransportCardService transportCardService =
      getIt<AbstractFgvTransportCardService>();

  // final inputTarjetaMask = MaskTextInputFormatter(
  //     mask: '#### #### ####',
  //     filter: {"#": RegExp(r'[0-9]')},
  //     type: MaskAutoCompletionType.lazy);

  Map checkedTransportCards = <int, TransportCard>{};

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
                              obtenerDatosTarjetaFgv(
                                  inputTarjetaController.text);
                            },
                            textInputAction: TextInputAction.go,
                            inputFormatters: [
                              TextInputMask(
                                  mask: tr('transportCards.cardNumberMask'))
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
                              obtenerDatosTarjetaFgv(
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
                itemCount: checkedTransportCards.keys.length,
                itemBuilder: (context, index) {
                  TransportCard iTransportCard = checkedTransportCards[
                      checkedTransportCards.keys
                          .toList()
                          .reversed
                          .toList()
                          .elementAt(index)];

                  return TarjetaCard(transportCard: iTransportCard);
                },
              ),
            ),
          ],
        ));
  }

  void obtenerDatosTarjetaFgv(String transportCardNumber) async {
    transportCardNumber = transportCardNumber.replaceAll(' ', '');

    FocusManager.instance.primaryFocus?.unfocus();
    LoaderUtils.setLoader();

    try {
      var resultTransportCard =
          await transportCardService.getTransportCard(transportCardNumber);

      setState(() {
        checkedTransportCards[int.parse(transportCardNumber)] =
            resultTransportCard;
      });
    } catch (e) {
      SnackbarUtils.textSnackbar(context, e.toString());
    } finally {
      LoaderUtils.dismissLoader();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    inputTarjetaController.dispose();
    super.dispose();
  }
}
