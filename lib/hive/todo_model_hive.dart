import 'package:hive/hive.dart';
part 'todo_model_hive.g.dart';

@HiveType(typeId: 0)
class TodoModelHive extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String location;

  TodoModelHive(
      {required this.name, required this.description, required this.location});
}
