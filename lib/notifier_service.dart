import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/internal/entity/entity.dart' as entity;
import 'package:flutter_notifier/internal/repository/isar/dbmodels/config.dart';
import 'package:flutter_notifier/internal/repository/isar/dbmodels/status.dart';
import 'package:flutter_notifier/internal/repository/isar/repository.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

import 'internal/entity/entity.dart';

const String targetPackage = "hr.asseco.android.kaspibusiness";

//TODO: merge this classes

class NotifierService {
  static ReceivePort receivePort = ReceivePort();
  static DefaultApi? apiClient;
  static IsarRepository? repo;

  @pragma('vm:entry-point')
  static void callback(ServiceNotificationEvent event) {
    repo ??= IsarRepository();

    if ((event.packageName ?? "") == targetPackage || true) {
      _processPost(event);
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

  static Future<void> _processPost(ServiceNotificationEvent event) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final config = await repo!.getConfig();
    final status = await repo!.getStatus();

    var amount = _extractAmountFromMessage(event.content ?? "");
    try {
      await NotifierService.apiClient!.addServiceAmount(
        ArgAddServiceAmount(
          hash: config?.hash ?? "",
          amount: _extractAmountFromMessage(event.content ?? ""),
        ),
      );

      await repo!.addEvent(
        AppNotificationEvent(
          null,
          event.packageName,
          event.title,
          timestamp,
          event.content,
          true,
          amount,
          config?.host ?? "NO_HOST",
          config?.title ?? "NO_POST",
          config?.hash ?? "NO_HASH",
        ),
      );
    } on ApiException catch (apiError) {
      await repo!.addEvent(
        AppNotificationEvent(
          null,
          event.packageName,
          event.title,
          timestamp,
          event.content,
          false,
          amount,
          config?.host ?? "NO_HOST",
          config?.title ?? "NO_POST",
          config?.hash ?? "NO_HASH",
          errorMessage: "Api Error #${apiError.code}",
        ),
      );
      if (kDebugMode) print(apiError);
    } catch (e) {
      await repo!.addEvent(
        AppNotificationEvent(
          null,
          event.packageName,
          event.title,
          timestamp,
          event.content,
          false,
          amount,
          config?.host ?? "NO_HOST",
          config?.title ?? "NO_POST",
          config?.hash ?? "NO_HASH",
          errorMessage: "Internal error",
        ),
      );
      if (kDebugMode) print(e);
    }

    final DateTime now = DateTime.now();
    const Duration day = Duration(days: 1);
  }
}

class ApiChecker {
  static IsarRepository? repo;
  static Timer? timer;
  static FlutterBackgroundService service = FlutterBackgroundService();

  static Future<void> init() async {
    ApiChecker.service.invoke("stopService");
    if (ApiChecker.timer != null) {
      ApiChecker.timer!.cancel();
    }
    await ApiChecker.service.configure(
        iosConfiguration: IosConfiguration(),
        androidConfiguration: AndroidConfiguration(
          isForegroundMode: true,
          onStart: ApiChecker.onStart,
          autoStart: true,
          autoStartOnBoot: true,
          initialNotificationTitle: "Flutter Notifier",
          initialNotificationContent: "Мониторинг уведомлений активен",
        ));
  }

  static Future<void> checkAPI() async {
    try {
      repo ??= IsarRepository(instance: "apiChecker");

      var status = await repo!.getStatus();
      status ??= entity.Status();

      try {
        var res = await NotifierService.apiClient!.getPing();
        status!.apiOk = true;
        if (kDebugMode) print("success api check");
      } catch (e) {
        status!.apiOk = false;
        if (kDebugMode) print("failed api check");
      }

      await repo!.updateStatus(status);
    } catch (e) {
      e.hashCode;
    }
  }

  static void initNotificationsListener() {
    statusSub ??= repo!.isar!.status.watchLazy();
    statusSub!.listen((event) {
      var status = repo!.getStatusSync();
      if (!ApiChecker.permisssionStatus || ApiChecker.permisssionStatus != (status?.permissionStatus ?? false)) {
        ApiChecker.sub?.cancel();
        ApiChecker.sub = NotificationListenerService.notificationsStream.listen((event) {
          NotifierService.callback(event);
        });
        ApiChecker.permisssionStatus == status?.permissionStatus ?? false;
      }
    });

    ApiChecker.sub?.cancel();
    ApiChecker.sub = NotificationListenerService.notificationsStream.listen((event) {
      NotifierService.callback(event);
    });
  }

  static bool permisssionStatus = false;
  static Stream<void>? statusSub;
  static Stream<void>? configSub;

  static StreamSubscription<ServiceNotificationEvent>? sub;

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    repo ??= IsarRepository();

    var config = await repo!.getConfig();
    if (config != null && config.host != null) {
      var apiClient = DefaultApi(ApiClient(basePath: "http://${config.host}"));
      if (config.pin != null) {
        apiClient.apiClient.addDefaultHeader("Pin", config.pin.toString());
      }

      NotifierService.apiClient = apiClient;
    }

    if (configSub == null) {
      ApiChecker.configSub ??= repo!.isar!.configs.watchLazy();

      configSub!.listen((event) async {
        var config = await repo!.getConfig();
        if (config != null && config.host != null) {
          var apiClient = DefaultApi(ApiClient(basePath: "http://${config.host}"));
          if (config.pin != null) {
            apiClient.apiClient.addDefaultHeader("Pin", config.pin.toString());
          }

          NotifierService.apiClient = apiClient;
        }
      });
    }

    initNotificationsListener();

    if (timer != null) {
      timer!.cancel();
    }

    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await checkAPI();
    });
  }
}
