import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/Models/notification_event_log.dart';
import 'package:flutter_notifier/hive_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String targetPackage = "hr.asseco.android.kaspibusiness";

class NotifierService {
  static NotifierService? instance;
  ReceivePort receivePort = ReceivePort();
  late DefaultApi apiClient;

  static Future<void> init() async {
    await initHive();

    var config = Hive.box(hiveConfigBox);

    NotifierService.instance = NotifierService();

    var apiClient = DefaultApi(
      ApiClient(basePath: config.get(hostKey) ?? ""),
    );
    apiClient.apiClient.addDefaultHeader("Pin", config.get(pinKey) ?? "");
    NotifierService.instance!.apiClient = apiClient;

    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(instance!.receivePort.sendPort, "_listener_");
    await initPlatformState();
  }

  static Future<void> initPlatformState() async {
    NotificationsListener.initialize(callbackHandle: _callback);
  }

  static Future<bool> startService() async {
    var hasPermission = await NotificationsListener.hasPermission;
    if (!(hasPermission ?? false)) {
      NotificationsListener.openPermissionSettings();
      return false;
    }

    var isR = await NotificationsListener.isRunning;

    if (isR ?? false) return true;

    return await NotificationsListener.startService(
          foreground: true,
          title: "FlutterNotifier",
          showWhen: true,
          description: "Мониторинг уведомлений активен",
        ) ??
        false;
  }

  static Future<bool> stopService() async {
    return await NotificationsListener.stopService() ?? false;
  }

  Future<void> updateApiClient() async {
    var config = Hive.box(hiveConfigBox);

    var apiClient = DefaultApi(
      ApiClient(basePath: config.get(hostKey) ?? ""),
    );
    apiClient.apiClient.addDefaultHeader("Pin", config.get(pinKey) ?? "");
    NotifierService.instance!.apiClient = apiClient;
  }

  static void _callback(NotificationEvent event) {
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");

    if ((event.packageName ?? "") == targetPackage) {
      _processPost(event);
      send?.send(event);
    }
  }

  static final _extractRegex = RegExp(r"-?((\d+\s?)+)\s?₸");
  static final _extractCleanRegex = RegExp(r"\s|₸");

  static int _extractAmountFromMessage(String message) {
    if (!message.contains("Оплата:")) return 0;

    var cleaned = _extractRegex.stringMatch(message)?.replaceAll(_extractCleanRegex, "") ?? "";
    var res = int.tryParse(cleaned) ?? 0;

    return res < 0 ? 0 : res;
  }

  static Future<void> _processPost(NotificationEvent event) async {
    await initHive();
    var config = Hive.box(hiveConfigBox);
    var logs = Hive.box(hiveLogsBox);

    int notificationTotal = logs.get(notificationTotalKey) ?? 0;
    List<dynamic> eventLog = logs.get(logKey);

    var amount = _extractAmountFromMessage(event.text ?? "");
    try {
      await NotifierService.instance?.apiClient.addServiceAmount(
        ArgAddServiceAmount(
          hash: config.get(postKey) ?? "",
          amount: _extractAmountFromMessage(event.text ?? ""),
        ),
      );
      eventLog.insert(
        0,
        NotificationEventLog(
          event.packageName,
          event.title,
          event.timestamp,
          event.text,
          true,
          amount,
          config.get(hostKey, defaultValue: "NO_HOST"),
          config.get(postTitleKey, defaultValue: "NO_POST"),
          config.get(postKey, defaultValue: "NO_HASH"),
        ),
      );
    } on ApiException catch (apiError) {
      eventLog.insert(
        0,
        NotificationEventLog(
          event.packageName,
          event.title,
          event.timestamp,
          event.text,
          false,
          amount,
          config.get(hostKey, defaultValue: "NO_HOST"),
          config.get(postTitleKey, defaultValue: "NO_POST"),
          config.get(postKey, defaultValue: "NO_HASH"),
          ErrorMessage: "Api Error #${apiError.code}",
        ),
      );
      if (kDebugMode) print(apiError);
    } catch (e) {
      eventLog.insert(
        0,
        NotificationEventLog(
          event.packageName,
          event.title,
          event.timestamp,
          event.text,
          false,
          amount,
          config.get(hostKey, defaultValue: "NO_HOST"),
          config.get(postTitleKey, defaultValue: "NO_POST"),
          config.get(postKey, defaultValue: "NO_HASH"),
          ErrorMessage: "Internal error",
        ),
      );
      if (kDebugMode) print(e);
    }

    final DateTime now = DateTime.now();
    const Duration day = Duration(days: 1);

    eventLog.removeWhere(
      (element) {
        if (element.Timestamp != null) {
          DateTime eventDate = DateTime.fromMillisecondsSinceEpoch(element.Timestamp!, isUtc: true).toLocal();
          return now.difference(eventDate) > day;
        }
        return false;
      },
    );

    logs.put(logKey, eventLog);
    logs.put(notificationTotalKey, notificationTotal + 1);
  }
}
