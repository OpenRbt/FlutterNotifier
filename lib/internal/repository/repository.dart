import 'package:flutter_notifier/internal/entity/entity.dart';

abstract class Repository {
  Future<void> init();

  Future<AppNotificationEvent?> getEvent(int id);

  AppNotificationEvent? getEventSync(int id);

  Future<DataList<AppNotificationEvent>> getEvents({int? offset, int? limit});

  Future<void> addEvent(AppNotificationEvent event);

  Future<Config?> getConfig();

  Config? getConfigSync();

  Future<void> updateConfig(Config config);

  Future<Status?> getStatus();

  Status? getStatusSync();

  Future<void> updateStatus(Status status);
}
