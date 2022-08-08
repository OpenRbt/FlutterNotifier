import 'package:flutter/material.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  static const String hostKey = "host";
  static const String pinKey = "pin";
  static const String postKey = "post_id";
  static const String postTitleKey = "post";
  static const String targetPackage = "hr.asseco.android.kaspibusiness";
}

class AppNotifierState {
  static ValueNotifier<AppNotifierState?> instance = ValueNotifier(null);

  late String? host;
  late String? post_id;
  late String? post;
  late String? pin;
  late DefaultApi apiClient;
  bool canProcess = false;

  Future<void> Init() async {
    final prefs = await SharedPreferences.getInstance();
    host = prefs.getString(Constants.hostKey);
    post_id = prefs.getString(Constants.postKey);
    post = prefs.getString(Constants.postTitleKey);
    pin = prefs.getString(Constants.pinKey);
    apiClient = DefaultApi(
      ApiClient(basePath: host ?? ""),
    );
    apiClient.apiClient.addDefaultHeader("Pin", pin ?? "");
    if (host == "" || ((post ?? "").isEmpty)) {
      canProcess = false;
    }
  }
}
