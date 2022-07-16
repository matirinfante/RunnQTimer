import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runnq/Models/Llegada.dart';
import 'package:runnq/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LlegadaEdit.dart';
import 'UpdateLlegada.dart';

//TODO DRAWER RESET
//TODO LIMPIAR CODIGO
class TimerCompanion extends StatefulWidget {
  TimerCompanion({Key? key}) : super(key: key);

  TimerCompanionState createState() => new TimerCompanionState();
}

class TimerCompanionState extends State<TimerCompanion> {
  int _indexGeneral = 0;
  late ScrollController _controller;

  late LlegadaDB _db;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    this._db = LlegadaDB();
    this._db.initializeDB().whenComplete(() async {
      _obtenerIndex();
      setState(() {});
    });
  }

  void _moverArriba() {
    _controller.animateTo(_controller.offset + 100,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  void didUpdateWidget(TimerCompanion oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  //Funcion que obtiene el indice actual almacenado en la base de datos
  void _obtenerIndex() async {
    List<Llegada> llegadas = await _db.getLlegadas();
    setState(() {
      _indexGeneral = llegadas.length;
    });
  }

  Future<String> pasarBDaJSON() async {
    //final file = await _localFile;
    String s = '[';
    List<Llegada> data = await _db.getLlegadas();
    data.forEach((element) {
      if (element == data.last) {
        s += jsonEncode(element);
        s += '\n';
      } else {
        s += jsonEncode(element);
        s += ',\n';
      }
    });
    // Write the file.
    s += ']';
    return s;
  }

  void _enviarDatos() async {
    String s = await pasarBDaJSON();
    //Share.text('json', s, 'application/json');
  }

  //Funcion que borra toda la tabla
  void resetDB() async {
    await _db.dropLlegada();
    var prefs = await SharedPreferences.getInstance();
    prefs.setInt('horaLargada', 0);
    setState(() {
      _indexGeneral = 0;
    });
  }

  //Funcion que agrega una llegada a la base de datos e incrementa el indexGeneral
  void _addLlegada() async {
    String timestamp = DateTime.now().toIso8601String();
    var _llegadaARegistrar = Llegada(
        id: _indexGeneral,
        tiempoLlegada: timestamp,
        numCorredor: null,
        registrado: 0);
    await _db.addLlegada(_llegadaARegistrar);
    setState(() {
      _indexGeneral += 1;
    });
    _moverArriba();
  }

  //Funcion que da formato HH:MM:SS:MS a un tiempo en milisegundos
  String timeFormatter(int time) {
    Duration duration = Duration(milliseconds: time);
    int milliseconds = (time % 1000);
    String formato = [
      duration.inHours,
      duration.inMinutes,
      duration.inSeconds,
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
    return '$formato:$milliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 8,
            child: FutureBuilder<List<Llegada>>(
              future: _db.getLlegadas(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Llegada>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    controller: _controller,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Llegada item = snapshot.data![index];
                      final tiempoFormatted = item.tiempoLlegada;
                      String numEquipo =
                          item.numCorredor ?? "Falta Número de Equipo";
                      return ListTile(
                        leading: const Icon(Icons.access_alarms),
                        title: Text('$tiempoFormatted - $numEquipo'),
                        trailing: Icon(item.registrado == 0
                            ? Icons.navigate_next
                            : Icons.check_circle),
                        onTap: () async {
                          if (item.registrado == 0) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => LlegadaEdit(
                                    tileIndex: index,
                                    formattedTime: tiempoFormatted)));
                          } else {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UpdateLlegada(
                                      tileIndex: index,
                                      formattedTime: tiempoFormatted,
                                      numCorredor: item.numCorredor,
                                    )));
                          }
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, index) {
                      return const Divider();
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        color: Colors.amber,
                        onPressed: () {
                          _addLlegada();
                        },
                        child: const Text("REGISTRAR"),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        color: Colors.deepOrangeAccent,
                        onPressed: _enviarDatos,
                        child: const Text("ENVIAR DATOS"),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
