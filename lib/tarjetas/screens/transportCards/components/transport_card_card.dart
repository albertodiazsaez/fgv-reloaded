import 'package:easy_localization/easy_localization.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/tarjetas/models/transport_card_data.dart';

class TarjetaCard extends StatelessWidget {
  const TarjetaCard({Key? key, required this.transportCard}) : super(key: key);

  final TransportCard transportCard;

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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(' ${maskTarjeta(transportCard.cardNumber)}')
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
                        Text(' ${transportCard.title}')
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15, top: 5),
                    child: Row(
                      children: [
                        Text(
                            tr('transportCards.card.cardClass') +
                                tr('symbols.colon'),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(' ${transportCard.cardClass}')
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
                        Text(' ${transportCard.zone}')
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
                          ' ${transportCard.balance}',
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: transportCard.validityDate != null,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Row(
                        children: [
                          Text(
                              tr('transportCards.card.validityDate') +
                                  tr('symbols.colon'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(transportCard.validityDate == null
                              ? ''
                              : ' ' +
                                  DateFormat(
                                          'dd-MM-yyyy',
                                          Localizations.maybeLocaleOf(context)
                                              ?.toLanguageTag())
                                      .format(transportCard.validityDate!))
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

  String maskTarjeta(String transportCardNumber) {
    return MagicMask.buildMask(tr('transportCards.cardNumberMask'))
        .getMaskedString(transportCardNumber);
  }
}
