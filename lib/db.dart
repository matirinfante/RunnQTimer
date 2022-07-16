import 'package:path/path.dart';
import 'package:runnq/Models/Llegada.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class LlegadaDB {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(join(path, 'llegadas.db'), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Llegada ("
          "id integer primary key unique,"
          "numCorredor text,"
          "tiempoLlegada text,"
          "registrado integer"
          ");");
    });
  }

  //Query LLEGADAS
  Future<List<Llegada>> getLlegadas() async {
    final db = await initializeDB();
    var result = await db.query("Llegada");
    List<Llegada> list = result.map((c) => Llegada.fromMap(c)).toList();
    return list;
  }

  //Query
  Future<Llegada?> getLlegada(int id) async {
    final db = await initializeDB();
    var result = await db.query("Llegada", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? Llegada.fromMap(result.first) : null;
  }

  //Query
  Future<Llegada?> getLlegadaByRunner(String numCorredor) async {
    final db = await initializeDB();
    var result = await db
        .query("Llegada", where: "numCorredor = ?", whereArgs: [numCorredor]);
    return result.isNotEmpty ? Llegada.fromMap(result.first) : null;
  }

  //Insert
  addLlegada(Llegada llegada) async {
    final db = await initializeDB();
    /*var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Llegada");
    int id = table.first["id"];
    llegada.id = id;*/
    var raw = await db.insert(
      "Llegada",
      llegada.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //Delete
  //Delete client with id
  deleteLlegada(int id) async {
    final db = await initializeDB();
    return db.delete("Llegada", where: "id = ?", whereArgs: [id]);
  }

  //Delete all clients
  dropLlegada() async {
    final db = await initializeDB();
    db.delete("Llegada");
    //db.rawQuery("DROP TABLE DatosLlegada");
  }

//Update
  updateLlegada(int id, String numCorredor, int registrado) async {
    final db = await initializeDB();
    var result = await db.update(
        'Llegada', {'numCorredor': numCorredor, 'registrado': registrado},
        where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //Update
  updateEquipo(int id, String numCorredor) async {
    final db = await initializeDB();
    var result = await db.update('Llegada', {'numCorredor': numCorredor},
        where: 'id = ?', whereArgs: [id]);
    return result;
  }
}
