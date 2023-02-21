import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/station_card.dart';
import 'package:metrovalencia_reloaded/models/station.dart';

class StationList extends StatefulWidget {
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
  State<StatefulWidget> createState() => _StationListState();
}

class _StationListState extends State<StationList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextFormField(
            // TODO: Add debouncing/delay time to avoid stuttering.
            onChanged: (searchInput) => widget.onSearch(searchInput),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(hintText: tr('stations.searchStation')),
          ),
        ),
        Expanded(
          child: ListView.builder(
            key: PageStorageKey(widget.scrollPageStorageKey),
            shrinkWrap: true,
            itemCount: widget.stationList.length,
            itemBuilder: (context, index) {
              Station stationToShow = widget.stationList.elementAt(index);
              return GestureDetector(
                onTap: () => widget.onStationSelected(stationToShow),
                child: StationCard(
                    stationToShow,
                    widget.favStationsFgvIdList.contains(stationToShow.fgvId),
                    widget.changeFavoriteStatus),
              );
            },
          ),
        )
      ],
    );
  }
}
