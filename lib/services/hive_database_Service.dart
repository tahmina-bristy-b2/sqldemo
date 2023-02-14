import 'package:hive/hive.dart';

class HiveDatabseServices {
  Future<void> createaTodo(Map<String, dynamic> todoModel) async {
    final hiveDatabseBox = Hive.box('TodoData');
    await hiveDatabseBox.add(todoModel);
    print("object==========${hiveDatabseBox.length}");
  }

  Future<void> readaTodo(Map<String, dynamic> todoModel) async {
    final hiveDatabseBox = Hive.box('TodoData');

    var data = await hiveDatabseBox.getAt(0);
    print("object==========${data}");
  }
}
