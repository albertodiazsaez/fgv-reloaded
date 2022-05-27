import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/screens/routes.dart';
import 'package:metrovalencia_reloaded/services/service_locator.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_station_service.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';
import 'package:metrovalencia_reloaded/utils/loader_utils.dart';

class Stations extends StatefulWidget {
  const Stations({Key? key}) : super(key: key);

  @override
  State<Stations> createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  AbstractFgvStationService stationService = getIt<AbstractFgvStationService>();

  @override
  Widget build(BuildContext context) {
    LoaderUtils.setLoader();
    return Column(
      children: [
        Container(
          child: Text('Futura barra de búsqueda'),
        ),
        const Divider(thickness: 1),
        FutureBuilder<List<Station>>(
          future: stationService.getStations(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Text('');
            } else {
              LoaderUtils.dismissLoader();
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.elementAt(index).name),
                        Row(
                          children: <Widget>[
                            for(var line in snapshot.data!.elementAt(index).lines!)LineNumber(line.id, HexColor(line.color), 20)
                          ],
                        )
                      ],
                    );
                  },
                ),
              );
            }
            ;
          },
        )
      ],
    );
  }
}
