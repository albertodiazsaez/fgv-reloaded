import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/station_card.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

class StationList extends StatelessWidget {
  const StationList(
      this.stationList,
      this.favStationsFgvIdList,
      this.onSearch,
      this.onStationSelected,
      this.changeFavoriteStatus,
      this.scrollPageStorageKey,
      {Key? key})
      : super(key: key);

  final List<Station> stationList;
  final List<int> favStationsFgvIdList;
  final Function(String search) onSearch;
  final Function(Station clickedStation) onStationSelected;
  final Function(Station clickedStation, bool isFavorite) changeFavoriteStatus;
  final String scrollPageStorageKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextFormField(
            // TODO: Add debouncing/delay time to avoid stuttering.
            onChanged: (searchInput) => onSearch(searchInput),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(hintText: tr('stations.searchStation')),
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: PageStorageKey(scrollPageStorageKey),
            shrinkWrap: true,
            itemCount: stationList.length,
            itemBuilder: (context, index) {
              Station stationToShow = stationList.elementAt(index);
              return GestureDetector(
                onTap: () => onStationSelected(stationToShow),
                child: StationCard(
                    stationToShow,
                    favStationsFgvIdList.contains(stationToShow.fgvId),
                    changeFavoriteStatus),
              );
            },
          ),
        )
      ],
    );
  }
}
