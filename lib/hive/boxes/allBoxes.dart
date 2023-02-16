import 'package:hive/hive.dart';
import 'package:sqflitedemo/hive/todo_model_hive.dart';

class Boxes {
  static Box<TodoModelHive> getTodoData() => Hive.box<TodoModelHive>('Todo');
}
