import 'dart:convert';

import 'package:flutter_notifier/Models/notification_event_log.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String configMigratedKey = "useConfigV2";

const String hiveConfigBox = "configuration";
const String hiveLogsBox = "logs";
const String logKey = " notification_event_log";
const String notificationTotalKey = " notification_total";

const String hostKey = "host";
const String pinKey = "pin";
const String postKey = "post_id";
const String postTitleKey = "post";

Future<void> initHive() async {
  await Hive.initFlutter();

  if (!(Hive.isBoxOpen(hiveConfigBox) && Hive.isBoxOpen(hiveLogsBox))) {
    Hive.registerAdapter(
      NotificationEventLogAdapter(),
      override: true,
    );

    const secureStorage = FlutterSecureStorage();
    final encryptingKey = await secureStorage.read(key: 'key');
    if (encryptingKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }
    final key = await secureStorage.read(key: 'key');
    final encryptionKey = base64Url.decode(key!);
    if (!Hive.isBoxOpen(hiveConfigBox)) {
      await Hive.openBox(
        hiveConfigBox,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    }
    if (!Hive.isBoxOpen(hiveLogsBox)) {
      var box = await Hive.openBox(hiveLogsBox, encryptionCipher: HiveAesCipher(encryptionKey), compactionStrategy: (entries, deletedEntries) {
        return deletedEntries > 100;
      });
      if (!box.containsKey(logKey)) box.put(logKey, <NotificationEventLog>[]);
      if (!box.containsKey(notificationTotalKey)) box.put(notificationTotalKey, 0);
    }
  }
}
