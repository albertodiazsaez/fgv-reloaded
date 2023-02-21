import 'package:diacritic/diacritic.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:metrovalencia_reloaded/components/station-selector/station_list.dart';
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

  List<Station> favStationsList = [];
  List<Station> filteredFavStationsList = [];
  List<int> favStationsIdList = [];
  @override
  void initState() {
    super.initState();
    favStationsIdList = [1, 2, 3, 4];
    LoaderUtils.setLoader();
    stationService
        .getStations()
        .then(
          (List<Station> value) => {
            setState(
              () => {
                stationsList = value,
                filteredStationsList = value,
                favStationsList = _getFavStations(value, favStationsIdList),
                filteredFavStationsList = favStationsList,
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Theme.of(context).colorScheme.primary,
                child: TabBar(
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  tabs: [
                    Tab(text: tr('stations.all')),
                    Tab(
                      text: tr('stations.favorites'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StationList(
                filteredStationsList,
                favStationsIdList,
                _filterStation,
                widget.onStationSelected,
                changeFavoriteStatus,
                "stationListScrollKey"),
            StationList(
                filteredFavStationsList,
                favStationsIdList,
                _filterFavStation,
                widget.onStationSelected,
                changeFavoriteStatus,
                "favStationListScrollKey")
          ],
        ),
      ),
    );
  }

  changeFavoriteStatus(Station station, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favStationsIdList.add(station.fgvId);
      } else {
        favStationsIdList.remove(station.fgvId);
      }

      filteredFavStationsList =
          _getFavStations(stationsList, favStationsIdList);
    });
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

  _filterFavStation(String searchInput) {
    setState(() {
      filteredFavStationsList = favStationsList
          .where((stationSearch) =>
              removeDiacritics(stationSearch.name.toLowerCase())
                  .contains(removeDiacritics(searchInput.toLowerCase())))
          .toList();
    });
  }

  _getFavStations(List<Station> stations, List<int> favStationsFgvIdList) {
    List<Station> favStations = [];
    stations.forEach((element) {
      if (favStationsIdList.contains(element.fgvId)) {
        favStations.add(element);
      }
    });
    return favStations;
  }
}
