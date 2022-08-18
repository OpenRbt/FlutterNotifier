import 'package:hive_flutter/hive_flutter.dart';

part 'notification_event_log.g.dart';

@HiveType(typeId: 0)
class NotificationEventLog {
  @HiveField(0)
  final String? PackageName;
  @HiveField(1)
  final String? Title;
  @HiveField(2)
  final int? Timestamp;
  @HiveField(3)
  final String? Text;

  @HiveField(4)
  final bool Success;
  @HiveField(5)
  String? ErrorMessage;

  @HiveField(6)
  final int Amount;
  @HiveField(7)
  final String? TargetHost;
  @HiveField(8)
  final String? TargetPost;
  @HiveField(9)
  final String? TargetHash;

  NotificationEventLog(this.PackageName, this.Title, this.Timestamp, this.Text, this.Success, this.Amount, this.TargetHost, this.TargetPost, this.TargetHash, {this.ErrorMessage});
}
