// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoModelHiveAdapter extends TypeAdapter<TodoModelHive> {
  @override
  final int typeId = 0;

  @override
  TodoModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoModelHive(
      name: fields[0] as String,
      description: fields[1] as String,
      location: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TodoModelHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
