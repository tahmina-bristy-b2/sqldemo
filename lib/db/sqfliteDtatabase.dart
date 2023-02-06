import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as join;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflitedemo/model/model.dart';

class SqfliteHelper {
  static const tableName = 'SqlDatabase';
  // static const id = 'id';
  // static const name = 'name';
  static const date = 'date';
  SqfliteHelper._privateInstance();
  static final SqfliteHelper instance = SqfliteHelper._privateInstance();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory getDirectory = await getApplicationDocumentsDirectory();
    String path = join.join(getDirectory.path, 'sqldatabase.db');

    return await openDatabase(path, version: 3, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String q = '''Create table SqlDatabase(
     id INTEGER PRIMARY KEY,
    name TEXT )''';
    await db.execute(q);
  }

  Future<List<TodoModel>> getTodoList() async {
    Database dbInstance = await instance.database;
    var data = await dbInstance.query('$tableName', orderBy: "name");
    List<TodoModel> singleData =
        data.isNotEmpty ? data.map((e) => TodoModel.fromMap(e)).toList() : [];
    return singleData;
  }
}
