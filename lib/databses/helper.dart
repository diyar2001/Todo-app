import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Sqlhelper {
  static Database? _db;

  static Future<Database> getdb() async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await opendb();
      return _db!;
    }
  }

  static Future<Database> opendb() async {
    final appdirectory = await getApplicationDocumentsDirectory();
    final dbpath = await join(appdirectory.path, 'Todoapp.db');
    final tododb =
        await openDatabase(dbpath, version: 1, onCreate: firstcreate);
    return tododb;
  }

  static Future<void> firstcreate(Database db, int version) async {
    var dutiestable = '''create table Duties(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          category Text,
          task Text)''';
    return db.execute(dutiestable);
  }

  static Future<void> closedb() async {
    var db = await getdb();
    db.close();
    _db = null;
  }

  static Future<void> addtodo(String category, String task) async {
    final db = await getdb();
    String query =
        "insert into Duties (category,task) values ('${category}','${task}')";
    db.rawQuery(query);
  }
  static Future<List> getcategory() async {
    final db = await getdb();
    String query = "select category,count(task) from Duties group by category order by category asc";
    List result = await db.rawQuery(query);
    return result.toList();
  }

  static Future<List> taskitems(String category) async {
    final db = await getdb();
    String query = "select * from Duties where category='${category}'";
    List result = await db.rawQuery(query);
    return result.toList();
  }

  static Future<void> delete(String category) async {
    final db = await getdb();
    db.delete('Duties', where: "ischecked=true and category='${category}'");
  }

  static Future<void> update(int id, bool check) async {
    final db = await getdb();
    String query = "update Duties set ischecked=${check} where id=${id}";
    db.rawQuery(query);
  }

  static Future countchecked(String category) async {
    final db = await getdb();
    String query =
        "select count(ischecked) as count from Duties where category= '${category}' and ischecked='1'";
    return db.rawQuery(query);
  }
}
