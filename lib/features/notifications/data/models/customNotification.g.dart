// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customNotification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomNotificationAdapter extends TypeAdapter<CustomNotification> {
  @override
  final int typeId = 0;

  @override
  CustomNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomNotification(
      id: fields[0] as int,
      title: fields[1] as String,
      type: fields[2] as String,
      message: fields[3] as String,
      sendTo: fields[4] as int?,
      image: fields[5] as String?,
      date: fields[6] as DateTime,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
      typeId: fields[10] as String?,
      deletedAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomNotification obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.sendTo)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.typeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
