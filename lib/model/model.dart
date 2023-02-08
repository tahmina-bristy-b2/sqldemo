class TodoModel {
  int? id;
  String name;

  TodoModel({this.id, required this.name});
  factory TodoModel.fromMap(Map<String, dynamic> json) =>
      TodoModel(id: json['id'], name: json['name']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
