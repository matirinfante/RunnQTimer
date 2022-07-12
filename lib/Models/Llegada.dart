class Llegada {
  int id, registrado;
  String? numCorredor, tiempoLlegada;

  Llegada(
      {required this.id,
      this.numCorredor,
      this.tiempoLlegada,
      required this.registrado});

  Map<String, dynamic> toMap() => {
        "id": id,
        "numCorredor": numCorredor,
        "tiempoLlegada": tiempoLlegada,
        "registrado": registrado
      };

  factory Llegada.fromMap(Map<String, dynamic> json) => Llegada(
      id: json["id"],
      numCorredor: json["numCorredor"],
      tiempoLlegada: json["tiempoLlegada"],
      registrado: json["registrado"]);

  Map<String, dynamic> toJson() => {
        "numCorredor": numCorredor,
        "tiempoLlegada": tiempoLlegada,
      };
}
