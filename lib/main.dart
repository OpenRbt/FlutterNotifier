import 'package:flutter/material.dart';
import 'package:flutter_notifier/Pages/home_page.dart';
import 'package:flutter_notifier/hive_helpers.dart' as helpers;
import 'package:flutter_notifier/hive_helpers.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notifier_service.dart';

void main() async {
  await helpers.initHive();

  var prefs = await SharedPreferences.getInstance();
  if (!(prefs.getBool(configMigratedKey) ?? false)) {
    await _migrateConfig(prefs);
  }

  if (NotifierService.instance == null) {
    await NotifierService.init();
  }

  runApp(const MyApp());
}

Future<void> _migrateConfig(SharedPreferences prefs) async {
  var box = Hive.box(hiveConfigBox);

  String? host = prefs.getString(hostKey);
  String? post = prefs.getString(postKey);
  String? postTitle = prefs.getString(postTitleKey);
  String? pin = prefs.getString(pinKey);

  prefs.setBool(configMigratedKey, true);
  if (host != null) {
    box.put(hostKey, host);
    prefs.setString(hostKey, "");
  }
  if (post != null) {
    box.put(postKey, post);
    prefs.setString(postKey, "");
  }
  if (postTitle != null) {
    box.put(postTitleKey, postTitle);
    prefs.setString(postTitleKey, "");
  }
  if (pin != null) {
    box.put(pinKey, pin);
    prefs.setString(pinKey, "");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifier',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}
