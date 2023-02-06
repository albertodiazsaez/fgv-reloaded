import 'package:diacritic/diacritic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/components/station_card.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/services/fgv/fgv_station_service.dart';
import 'package:metrovalencia_reloaded/services/service_locator.dart';
import 'package:metrovalencia_reloaded/utils/loader_utils.dart';
import 'package:metrovalencia_reloaded/utils/snackbar_utils.dart';

class StationSelector extends StatefulWidget {
  const StationSelector(this.onStationSelected, {Key? key}) : super(key: key);

  @override
  State<StationSelector> createState() => _StationSelectorState();

  final Function(Station clickedStation) onStationSelected;
}

// TODO: Separate list from component to reuse in (for example) selecting station in timetable selection.
class _StationSelectorState extends State<StationSelector> {
  List<Station> stationsList = [];
  List<Station> filteredStationsList = [];

  @override
  void initState() {
    super.initState();
    LoaderUtils.setLoader();
    stationService
        .getStations()
        .then(
          (List<Station> value) => {
            setState(
              () => {
                stationsList = value,
                filteredStationsList = value,
                LoaderUtils.dismissLoader(),
              },
            ),
          },
        )
        .catchError((e) {
      LoaderUtils.dismissLoader();
      SnackbarUtils.textSnackbar(context, e.toString());
    });
  }

  AbstractFgvStationService stationService = getIt<AbstractFgvStationService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextFormField(
            // TODO: Add debouncing/delay time to avoid stuttering.
            onChanged: (searchInput) => _filterStation(searchInput),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(hintText: tr('stations.searchStation')),
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredStationsList.length,
            itemBuilder: (context, index) {
              Station stationToShow = filteredStationsList.elementAt(index);
              return GestureDetector(
                onTap: () => widget.onStationSelected(stationToShow),
                child: StationCard(
                  stationToShow,
                ),
              );
            },
          ),
        )
      ],
    );
  }

  _filterStation(String searchInput) {
    setState(() {
      filteredStationsList = stationsList
          .where((stationSearch) =>
              removeDiacritics(stationSearch.name.toLowerCase())
                  .contains(removeDiacritics(searchInput.toLowerCase())))
          .toList();
    });
  }
}
