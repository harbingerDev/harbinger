// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectsAdapter extends TypeAdapter<Projects> {
  @override
  final int typeId = 0;

  @override
  Projects read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Projects()
      ..projectName = fields[0] as String
      ..projectPath = fields[1] as String
      ..isActive = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, Projects obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.projectName)
      ..writeByte(1)
      ..write(obj.projectPath)
      ..writeByte(2)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
