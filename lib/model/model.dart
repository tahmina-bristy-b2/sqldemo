class TodoModel {
  int? id;
  String name;
  String description;
  String location;

  TodoModel(
      {this.id,
      required this.name,
      required this.description,
      required this.location});
  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location']);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location
    };
  }
}
