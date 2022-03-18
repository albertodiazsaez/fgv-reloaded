import 'package:flutter/material.dart';

class DatosTarjeta {
  int numeroTarjeta;
  String? titulo;
  String? zona;
  String? clase;
  String? saldo;

  DatosTarjeta(
      {required this.numeroTarjeta,
      this.titulo,
      this.zona,
      this.clase,
      this.saldo});
}
