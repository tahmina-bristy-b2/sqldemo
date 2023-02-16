import 'package:hive/hive.dart';
import 'package:sqflitedemo/hive/boxes/allBoxes.dart';
import 'package:sqflitedemo/hive/todo_model_hive.dart';

class HiveDatabseServices {
  Future<void> createaTodo(TodoModelHive todoModel) async {
    Box<TodoModelHive> createTodoList = Boxes.getTodoData();
    createTodoList.add(todoModel);
    var a = createTodoList.length;
  }

  Future<void> editTodo(int selectedId, TodoModelHive todomodel) async {
    final box = Boxes.getTodoData();

    box.putAt(selectedId, todomodel);
  }

  Future<void> deleteTodo(int uniqueKey) async {
    final box = Boxes.getTodoData();
    print("delete e asche******************************************");
    box.values.forEach((element) {
      if (element.key == uniqueKey) {
        element.delete();
        print("delete hoyeche ******************************************");
      }
    });
  }
// Future<void> deleteTodo(){

// }
}
