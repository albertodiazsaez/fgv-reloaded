import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPerm {
  static showLocationPermissionDialog(BuildContext context) {
    Geolocator.checkPermission().then((value) => {
          if (value == LocationPermission.unableToDetermine ||
              value == LocationPermission.denied)
            {
              showDialog(
                context: context,
                builder: (
                  BuildContext context,
                ) =>
                    SimpleDialog(
                  title: Text('Permisos de Ubicación'),
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 0),
                      child: Text(
                        'Vamos a solicitar permisos de ubicación. Solo son necesarios para encontrar las estaciones más cercanas a tu posición, el resto de funcionalidades no se ven afectadas si decides no conceder este permiso.',
                        softWrap: true,
                        textWidthBasis: TextWidthBasis.parent,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: SimpleDialogOption(
                        onPressed: () => {},
                        child: TextButton(
                          onPressed: () => {
                            Navigator.pop(context),
                            isServiceEnabled(),
                            Geolocator.requestPermission(),
                          },
                          child: Text('Vale'),
                        ),
                      ),
                    )
                  ],
                ),
              )
            }
        });
  }

  static Future<bool> isServiceEnabled() async {
    bool result = await Geolocator.isLocationServiceEnabled();

    if (!result) {
      await Geolocator.openLocationSettings();
    }

    result = await Geolocator.isLocationServiceEnabled();

    return Future(() => result);
  }
}
