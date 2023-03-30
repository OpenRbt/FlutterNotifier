part of 'entity.dart';

class AppNotificationEvent {
  final int? id;
  final String? packageName;
  final String? title;
  final int? timestamp;
  final String? text;

  final bool success;
  String? errorMessage;

  final int amount;
  final String? targetHost;
  final String? targetPost;
  final String? targetHash;

  AppNotificationEvent(this.id, this.packageName, this.title, this.timestamp, this.text, this.success, this.amount, this.targetHost, this.targetPost, this.targetHash, {this.errorMessage});
}
