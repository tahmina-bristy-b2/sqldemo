class TodoModel {
  int? id;
  String name;
  String description;

  TodoModel({this.id, required this.name, required this.description});
  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
      id: json['id'], name: json['name'], description: json['description']);
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
