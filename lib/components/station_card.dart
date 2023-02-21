import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:metrovalencia_reloaded/components/line_number.dart';
import 'package:metrovalencia_reloaded/models/station.dart';
import 'package:metrovalencia_reloaded/utils/hex_color.dart';

class StationCard extends StatefulWidget {
  const StationCard(
    this.station,
    this.isFavorite,
    this.changeFavoriteStatus, {
    Key? key,
  }) : super(key: key);

  final Station station;
  final bool isFavorite;
  final Function(Station station, bool isFavorite) changeFavoriteStatus;

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 2.5),
                    child: Text(
                      widget.station.name,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 2.5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        for (var line in widget.station.lines!)
                          LineNumber(line.id, HexColor(line.color), 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: IconButton(
                  iconSize: 25,
                  splashRadius: 20,
                  icon:
                      Icon(widget.isFavorite ? Icons.star : Icons.star_border),
                  color: widget.isFavorite ? Colors.amber : null,
                  onPressed: () => setState(
                        () => {
                          widget.changeFavoriteStatus(
                              widget.station, !widget.isFavorite)
                        },
                      )),
            )
          ],
        ),
      ),
    );
  }
}
