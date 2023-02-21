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
import 'package:shared_preferences/shared_preferences.dart';

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
    LoaderUtils.setLoader();
    stationService
        .getStations()
        .then(
          (List<Station> value) => {
            setState(
              () => {
                _loadPrefFavStations().then((favsIds) => {
                      favStationsIdList = favsIds,
                      stationsList = value,
                      filteredStationsList = value,
                      favStationsList =
                          _getFavStations(value, favStationsIdList),
                      filteredFavStationsList = favStationsList,
                      LoaderUtils.dismissLoader(),
                    }),
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

  changeFavoriteStatus(Station station, bool isFavorite) async {
    setState(() {
      if (isFavorite) {
        favStationsIdList.add(station.fgvId);
        // When is favorite, we update the filtered list with all stations,
        //to include the new added one.
        filteredFavStationsList =
            _getFavStations(stationsList, favStationsIdList);
      } else {
        favStationsIdList.remove(station.fgvId);
        // When is not favorite, we update the filtered list with only filtered stations,
        // to avoid showing all stations while searching.
        filteredFavStationsList =
            _getFavStations(filteredFavStationsList, favStationsIdList);
      }
      favStationsList = _getFavStations(stationsList, favStationsIdList);
    });

    await _updatePrefsFavStations();
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
      if (favStationsFgvIdList.contains(element.fgvId)) {
        favStations.add(element);
      }
    });
    return favStations;
  }

  _updatePrefsFavStations() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favStationsFgvIdsToSave = [];
    favStationsIdList.forEach((element) {
      favStationsFgvIdsToSave.add(element.toString());
    });
    prefs.setStringList("FAV_STATIONS_FGV_ID", favStationsFgvIdsToSave);
  }

  Future<List<int>> _loadPrefFavStations() async {
    final prefs = await SharedPreferences.getInstance();

    List<int> result = [];
    List<String>? prefsFavs = [];
    prefsFavs
        .addAll(prefs.getStringList("FAV_STATIONS_FGV_ID") as Iterable<String>);
    if (prefsFavs.isNotEmpty) {
      prefsFavs.forEach((element) {
        result.add(int.parse(element));
      });
    }
    return result;
  }
}
