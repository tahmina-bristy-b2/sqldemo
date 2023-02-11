import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as join;
import 'package:permission_handler/permission_handler.dart';
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
  //if(Database)

  Future<Database> _initDatabase() async {
    //Directory getDirectory = await getApplicationDocumentsDirectory();
    //String path = join.join(getDirectory.path, 'sqldatabase.db');

    // late Database db;
    Directory databaseDir =
        Directory('/storage/emulated/0/Download/sql_db_folder');
    _createFolder(databaseDir);

    return await openDatabase('${databaseDir.path}/mydatabase.db',
        password: '123', version: 3, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String q = '''Create table SqlDatabase(
     id INTEGER PRIMARY KEY,
    name TEXT )''';
    await db.execute(q);
  }

  Future<List<TodoModel>> getTodoList() async {
    Database dbInstance = await instance.database;
    var data = await dbInstance.query('$tableName', orderBy: "id");
    List<TodoModel> singleData =
        data.isNotEmpty ? data.map((e) => TodoModel.fromMap(e)).toList() : [];
    return singleData;
  }

  Future<int> createTodoList(TodoModel toModel) async {
    Database dbInstance = await instance.database;
    return await dbInstance.insert('$tableName', toModel.toMap());
  }

  Future<int> removeTodoList(int id) async {
    Database dbInstance = await instance.database;
    return await dbInstance
        .delete('$tableName', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTodoList(TodoModel todoModel) async {
    Database dbInstance = await instance.database;
    return await dbInstance.update('$tableName', todoModel.toMap(),
        where: 'id = ?', whereArgs: [todoModel.id]);
  }

  Future<void> _createFolder(Directory dir) async {
    if (!await Permission.storage.status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
    } else {
      dir.create();

      print('#####Create Folder');
    }
  }
}
