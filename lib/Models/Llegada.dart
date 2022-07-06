class Llegada {
  int id, registrado, respuestasCorrectas;
  String numCorredor, tiempoLlegada;

  Llegada(
      {required this.id,
      required this.numCorredor,
      required this.tiempoLlegada,
      required this.respuestasCorrectas,
      required this.registrado});

  Map<String, dynamic> toMap() => {
        "id": id,
        "numCorredor": numCorredor,
        "tiempoLlegada": tiempoLlegada,
        "respuestasCorrectas": respuestasCorrectas,
        "registrado": registrado
      };

  factory Llegada.fromMap(Map<String, dynamic> json) => Llegada(
      id: json["id"],
      numCorredor: json["numCorredor"],
      tiempoLlegada: json["tiempoLlegada"],
      respuestasCorrectas: json["respuestasCorrectas"],
      registrado: json["registrado"]);

  Map<String, dynamic> toJson() => {
        "numCorredor": numCorredor,
        "tiempoLlegada": tiempoLlegada,
        "respuestasCorrectas": respuestasCorrectas
      };
}
