import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/Constants.dart';

class ProcessedEventInfo {
  final NotificationEvent event;
  final bool Success;
  final int Amount;
  final String? TargetPost;
  final String? TargetHash;

  const ProcessedEventInfo(this.event, this.Success, this.Amount, this.TargetPost, this.TargetHash);
}

class NotifierService {
  static NotifierService? instance;
  static List<ProcessedEventInfo> lastEvents = [];
  ReceivePort Port = ReceivePort();

  static Future<void> init() async {
    if (AppNotifierState.instance.value == null) {
      await AppNotifierState.updateInstance();
    }

    NotifierService.instance = NotifierService();
    IsolateNameServer.removePortNameMapping("_listener_");
    IsolateNameServer.registerPortWithName(instance!.Port.sendPort, "_listener_");
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

  static void _callback(NotificationEvent event) {
    final SendPort? send = IsolateNameServer.lookupPortByName("_listener_");

    if ((event.packageName ?? "") == Constants.targetPackage) {
      _processPost(event);
      send?.send(event);
    }
  }

  static void _dummyLog(NotificationEvent event) {
    lastEvents.add(
      ProcessedEventInfo(
        event,
        true,
        lastEvents.length + 1,
        AppNotifierState.instance.value?.host ?? "NO_HOST",
        "${AppNotifierState.instance.value?.post ?? "NO_POST"} : ${AppNotifierState.instance.value?.post_id ?? "NO_HASH"}",
      ),
    );
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
    if (AppNotifierState.instance.value == null) {
      await AppNotifierState.updateInstance();
    }
    var notifierState = AppNotifierState.instance.value;

    var amount = _extractAmountFromMessage(event.text ?? "");
    try {
      notifierState?.apiClient.addServiceAmount(
        ArgAddServiceAmount(
          hash: notifierState.post_id,
          amount: _extractAmountFromMessage(event.text ?? ""),
        ),
      );
      lastEvents.add(ProcessedEventInfo(event, true, amount, notifierState?.post, notifierState?.post_id));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (lastEvents.length > 100) {
      lastEvents.removeAt(0);
    }
  }
}
