import 'package:easy_localization/easy_localization.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/tarjetas/models/datos_tarjeta.dart';

class TarjetaCard extends StatelessWidget {
  const TarjetaCard({Key? key, required this.tarjeta}) : super(key: key);

  final DatosTarjeta tarjeta;

  @override
  Widget build(BuildContext context) {
    bool isScreenWide = MediaQuery.of(context).size.width >= 500;
    return SizedBox(
      child: Card(
        margin: const EdgeInsets.only(bottom: 5),
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
                            width: 0.5,
                            color: Theme.of(context).dividerColor))),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(
                          tr('transportCards.card.cardNumber') +
                              tr('symbols.colon'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(' ${maskTarjeta(tarjeta.numeroTarjeta)}')
                    ],
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              Flex(
                direction: isScreenWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                            tr('transportCards.card.title') +
                                tr('symbols.colon'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(' ${tarjeta.titulo}')
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                            tr('transportCards.card.class') +
                                tr('symbols.colon'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(' ${tarjeta.clase}')
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                            tr('transportCards.card.zone') +
                                tr('symbols.colon'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(' ${tarjeta.zona}')
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                            tr('transportCards.card.balance') +
                                tr('symbols.colon'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          ' ${tarjeta.saldo}',
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: tarjeta.fechaValidez != null,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Row(
                        children: [
                          Text(
                              tr('transportCards.card.validityDate') +
                                  tr('symbols.colon'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(tarjeta.fechaValidez == null
                              ? ''
                              : ' ' +
                                  DateFormat(
                                          'dd-MM-yyyy',
                                          Localizations.maybeLocaleOf(context)
                                              ?.toLanguageTag())
                                      .format(tarjeta.fechaValidez!))
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String maskTarjeta(String numeroTarjeta) {
    return MagicMask.buildMask(tr('transportCards.cardNumberMask')).getMaskedString(numeroTarjeta);
  }
}
