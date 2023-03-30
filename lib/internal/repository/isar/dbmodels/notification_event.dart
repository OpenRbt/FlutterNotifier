import 'package:isar/isar.dart';

part 'notification_event.g.dart';

@collection
class NotificationEvent {
  Id id = Isar.autoIncrement;
  String? packageName;
  String? title;
  int? timestamp;
  String? text;

  bool? success;
  String? errorMessage;

  int? amount;
  String? targetHost;
  String? targetPost;
  String? targetHash;

  NotificationEvent({this.packageName, this.title, this.timestamp, this.text, this.success, this.errorMessage, this.amount, this.targetHost, this.targetPost, this.targetHash});
}
