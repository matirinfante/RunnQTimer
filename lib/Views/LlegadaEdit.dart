import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:runnq/Views/TimerCompanion.dart';

import '../Models/Llegada.dart';
import '../db.dart';

class LlegadaEdit extends StatefulWidget {
  int tileIndex;
  String formattedTime;

  LlegadaEdit({Key? key, required this.tileIndex, required this.formattedTime})
      : super(key: key);

  @override
  _LlegadaEditState createState() => _LlegadaEditState();
}

class _LlegadaEditState extends State<LlegadaEdit> {
  Llegada? _datosLlegada;
  String? _numCorredor;
  bool _datosCargados = false;

  late LlegadaDB _db;

  @override
  void initState() {
    super.initState();
    this._db = LlegadaDB();
    this._db.initializeDB().whenComplete(() async {
      await _checkIfRegistered();
      setState(() {});
    });
  }

  _checkIfRegistered() async {
    var object = await _db.getLlegada(widget.tileIndex);
    print(object);
    if (object?.registrado != 0) {
      setState(() {
        _datosCargados = true;
      });
    }
  }

  _subirDatos() async {
    if (_numCorredor != null) {
      if (await _db.getLlegadaByRunner(_numCorredor!) != null) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: AlertDialog(
                  content: Text('EQUIPO YA AGREGADO!'),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    )
                  ],
                ),
              );
            });
      } else {
        _datosLlegada = Llegada(
            numCorredor: _numCorredor,
            tiempoLlegada: widget.formattedTime,
            registrado: 1);
        String _json = jsonEncode(_datosLlegada);
        print(_json);
        await _db.updateLlegada(widget.tileIndex, _numCorredor!, 1);
        setState(() {
          _datosCargados = true;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => TimerCompanion()),
            (Route<dynamic> route) => false);
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Imposible subir datos de llegada'),
              content: const Text('Verifique que los campos no esten vacios.'),
              actions: <Widget>[
                MaterialButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar datos de llegada'),
      ),
      body: Container(
        child: Center(
          child: Column(children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text('Tiempo registrado:'),
                  Text(widget.formattedTime),
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text('Número de Corredor:'),
                  SizedBox(
                    width: 70,
                    child: TextField(
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (value) async {
                        _numCorredor = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
                onPressed: _datosCargados ? null : _subirDatos,
                color: Colors.amber,
                child: const Text('Subir datos'),
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
