// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_event_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationEventLogAdapter extends TypeAdapter<NotificationEventLog> {
  @override
  final int typeId = 0;

  @override
  NotificationEventLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationEventLog(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as int?,
      fields[3] as String?,
      fields[4] as bool,
      fields[6] as int,
      fields[7] as String?,
      fields[8] as String?,
      fields[9] as String?,
      ErrorMessage: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationEventLog obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.PackageName)
      ..writeByte(1)
      ..write(obj.Title)
      ..writeByte(2)
      ..write(obj.Timestamp)
      ..writeByte(3)
      ..write(obj.Text)
      ..writeByte(4)
      ..write(obj.Success)
      ..writeByte(5)
      ..write(obj.ErrorMessage)
      ..writeByte(6)
      ..write(obj.Amount)
      ..writeByte(7)
      ..write(obj.TargetHost)
      ..writeByte(8)
      ..write(obj.TargetPost)
      ..writeByte(9)
      ..write(obj.TargetHash);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationEventLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
