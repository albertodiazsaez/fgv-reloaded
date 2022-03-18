class ResultadoConsultaTarjetaMetrovalencia {
  int? status;
  int? error;
  TarjetaMetrovalencia? resultado;

  ResultadoConsultaTarjetaMetrovalencia(
      {this.status, this.error, this.resultado});

  ResultadoConsultaTarjetaMetrovalencia.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    resultado = json['resultado'] != null
        ? TarjetaMetrovalencia.fromJson(json['resultado'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    if (resultado != null) {
      data['resultado'] = resultado!.toJson();
    }
    return data;
  }
}

class TarjetaMetrovalencia {
  String? tituloId;
  String? titulo;
  String? zona;
  dynamic saldo;
  String? fecha;
  String? ampliado;
  dynamic acumulado;
  int? importe;
  String? clase;
  String? recargable;
  dynamic minCredit;
  dynamic maxCredit;
  dynamic modCredit;
  dynamic pasoCredit;
  String? minViajes;
  dynamic nuevaValidez;
  Notas? notas;

  TarjetaMetrovalencia(
      {this.tituloId,
      this.titulo,
      this.zona,
      this.saldo,
      this.fecha,
      this.ampliado,
      this.acumulado,
      this.importe,
      this.clase,
      this.recargable,
      this.minCredit,
      this.maxCredit,
      this.modCredit,
      this.pasoCredit,
      this.minViajes,
      this.nuevaValidez,
      this.notas});

  TarjetaMetrovalencia.fromJson(Map<String, dynamic> json) {
    tituloId = json['titulo_id'];
    titulo = json['titulo'];
    zona = json['zona'];
    saldo = json['saldo'];
    fecha = json['fecha'];
    ampliado = json['ampliado'];
    acumulado = json['acumulado'];
    importe = json['importe'];
    clase = json['clase'];
    recargable = json['recargable'];
    minCredit = json['min_credit'];
    maxCredit = json['max_credit'];
    modCredit = json['mod_credit'];
    pasoCredit = json['paso_credit'];
    minViajes = json['min_viajes'];
    nuevaValidez = json['nueva_validez'];
    notas = json['notas'] != null ? Notas.fromJson(json['notas']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['titulo_id'] = tituloId;
    data['titulo'] = titulo;
    data['zona'] = zona;
    data['saldo'] = saldo;
    data['fecha'] = fecha;
    data['ampliado'] = ampliado;
    data['acumulado'] = acumulado;
    data['importe'] = importe;
    data['clase'] = clase;
    data['recargable'] = recargable;
    data['min_credit'] = minCredit;
    data['max_credit'] = maxCredit;
    data['mod_credit'] = modCredit;
    data['paso_credit'] = pasoCredit;
    data['min_viajes'] = minViajes;
    data['nueva_validez'] = nuevaValidez;
    if (notas != null) {
      data['notas'] = notas!.toJson();
    }
    return data;
  }
}

class Notas {
  String? es;
  String? ca;
  String? en;

  Notas({this.es, this.ca, this.en});

  Notas.fromJson(Map<String, dynamic> json) {
    es = json['ES'];
    ca = json['CA'];
    en = json['EN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ES'] = es;
    data['CA'] = ca;
    data['EN'] = en;
    return data;
  }
}
