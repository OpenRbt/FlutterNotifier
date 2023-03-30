import 'package:flutter_notifier/internal/entity/entity.dart' as entity;
import 'package:flutter_notifier/internal/repository/isar/dbmodels/config.dart';
import 'package:flutter_notifier/internal/repository/isar/dbmodels/notification_event.dart';
import 'package:flutter_notifier/internal/repository/isar/dbmodels/status.dart';
import 'package:flutter_notifier/internal/repository/repository.dart';
import 'package:isar/isar.dart';

class IsarRepository extends Repository {
  Isar? isar;
  IsarRepository({String? instance}) {
    final instance = Isar.getInstance();
    if (instance != null) {
      isar = instance;
      return;
    }

    isar = Isar.openSync(
      [NotificationEventSchema, ConfigSchema, StatusSchema],
    );
  }

  @override
  Future<void> init() async {}

  @override
  Future<void> addEvent(entity.AppNotificationEvent event) async {
    final newEvent = NotificationEvent(
        packageName: event.packageName,
        title: event.title,
        timestamp: event.timestamp,
        text: event.text,
        success: event.success,
        errorMessage: event.errorMessage,
        amount: event.amount,
        targetHost: event.targetHost,
        targetPost: event.targetPost,
        targetHash: event.targetHash);

    await isar!.writeTxn(() async {
      await isar!.notificationEvents.put(newEvent);
    });
  }

  @override
  Future<entity.AppNotificationEvent?> getEvent(int id) async {
    final event = await isar!.notificationEvents.get(id);
    return event != null ? notificationEventToEntity(event) : null;
  }

  @override
  entity.AppNotificationEvent? getEventSync(int id) {
    final event = isar!.notificationEvents.getSync(id);
    return event != null ? notificationEventToEntity(event) : null;
  }

  @override
  Future<entity.DataList<entity.AppNotificationEvent>> getEvents({int? offset, int? limit}) async {
    final events = await isar!.notificationEvents.where().offset(offset ?? 0).limit(limit ?? 0).findAll();
    final total = await isar!.notificationEvents.count();
    return eventsToEntity(events, total);
  }

  @override
  Future<entity.Config?> getConfig() async {
    final config = await isar!.configs.where().findFirst();
    if (config == null) {
      return null;
    }

    return configToEntity(config);
  }

  @override
  entity.Config? getConfigSync() {
    final config = isar!.configs.where().findFirstSync();
    if (config == null) {
      return null;
    }

    return configToEntity(config);
  }

  @override
  Future<void> updateConfig(entity.Config config) async {
    await isar!.writeTxn(() async {
      final oldConfig = await isar!.configs.where().findFirst();
      if (oldConfig != null) {
        isar!.configs.delete(oldConfig.id);
      }

      isar!.configs.put(Config(
        host: config.host,
        port: config.port,
        hash: config.hash,
        title: config.title,
        pin: config.pin,
      ));
    });
  }

  @override
  Future<entity.Status?> getStatus() async {
    final status = await isar!.status.where().findFirst();
    if (status == null) {
      return null;
    }

    return statusToEntity(status);
  }

  @override
  entity.Status? getStatusSync() {
    final status = isar!.status.where().findFirstSync();
    if (status == null) {
      return null;
    }

    return statusToEntity(status);
  }

  @override
  Future<void> updateStatus(entity.Status status) async {
    await isar!.writeTxn(() async {
      final oldStatus = await isar!.status.where().findFirst();
      if (oldStatus != null) {
        isar!.status.delete(oldStatus.id);
      }
      isar!.status.put(Status(apiOk: status.apiOk, permissionStatus: status.permissionStatus));
    });
  }

  entity.Config? configToEntity(Config config) {
    return entity.Config(
      host: config.host,
      port: config.port,
      hash: config.hash,
      title: config.title,
      pin: config.pin,
    );
  }

  entity.DataList<entity.AppNotificationEvent> eventsToEntity(List<NotificationEvent> events, int total) {
    return entity.DataList(
      items: List.generate(events.length, (index) => notificationEventToEntity(events[index])),
      total: total,
    );
  }

  entity.AppNotificationEvent notificationEventToEntity(NotificationEvent event) {
    return entity.AppNotificationEvent(
      event.id,
      event.packageName,
      event.title,
      event.timestamp,
      event.text,
      event.success ?? false,
      event.amount ?? -1,
      event.targetHost,
      event.targetPost,
      event.targetHash,
    );
  }

  entity.Status statusToEntity(Status status) {
    return entity.Status(apiOk: status.apiOk, permissionStatus: status.permissionStatus);
  }
}
