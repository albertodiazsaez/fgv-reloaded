import 'package:flutter/material.dart';

class DatosTarjeta {
  String numeroTarjeta;
  String? titulo;
  String? zona;
  String? clase;
  DateTime? fechaValidez;
  dynamic saldo;

  DatosTarjeta(
      {required this.numeroTarjeta,
      this.titulo,
      this.zona,
      this.clase,
      this.fechaValidez,
      this.saldo});
}
