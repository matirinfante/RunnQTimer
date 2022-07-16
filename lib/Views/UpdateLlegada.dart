import 'package:flutter/material.dart';
import 'package:runnq/Views/TimerCompanion.dart';

import '../db.dart';

//TODO AGREGAR CAMPO RESPUESTAS CORRECTAS
class UpdateLlegada extends StatefulWidget {
  int tileIndex;
  String formattedTime;
  String? numCorredor;

  UpdateLlegada({
    required this.tileIndex,
    required this.formattedTime,
    required this.numCorredor,
  });

  @override
  _UpdateLlegadaState createState() => _UpdateLlegadaState();
}

class _UpdateLlegadaState extends State<UpdateLlegada> {
  late String _numCorredor;
  late LlegadaDB _db;

  @override
  void initState() {
    super.initState();
    this._db = LlegadaDB();
    this._db.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    _numCorredor = widget.numCorredor!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar datos de llegada'),
      ),
      body: Center(
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
          const Divider(),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text('Número de Corredor:'),
                SizedBox(
                  width: 70,
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: _numCorredor,
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    onChanged: (value) async {
                      if (await _db.getLlegadaByRunner(value) == null) {
                        await _db.updateEquipo(widget.tileIndex, value);
                      } else {}
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => TimerCompanion()),
                    (Route<dynamic> route) => false);
              },
              color: Colors.amber,
              child: const Text('Listo'),
            ),
          ))
        ]),
      ),
    );
  }
}
