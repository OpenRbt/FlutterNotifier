import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_notifier/Constants.dart';
import 'package:flutter_notifier/Screens/ConfigPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool started = false;
  bool _loading = false;

  ValueNotifier<int> _totalNotificationHandled = ValueNotifier(0);

  // ValueNotifier<List<NotificationListPanel>> notifications = ValueNotifier([]);

  void onData(NotificationEvent event) {
    if (event.packageName == Constants.targetPackage) {
      ProcessPost(event);
    }
  }

  void ProcessPost(NotificationEvent event) {
    _totalNotificationHandled.value = _totalNotificationHandled.value + 1;
    // TODO: parse message and send money to post
    // AppNotifierState.instance.value.apiClient?.
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    NotificationsListener.receivePort?.listen((evt) => {onData(evt)});
    startListening();
  }

  @override
  void initState() {
    initPlatformState();
    super.initState();
  }

  void startListening() async {
    var hasPermission = await NotificationsListener.hasPermission;
    if (!(hasPermission ?? false)) {
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!(isR ?? false)) {
      await NotificationsListener.startService(foreground: true, title: "FlutterNotifier", description: "Мониторинг уведомлений активен");
    }

    setState(() => started = true);
  }

  void stopListening() async {
    setState(() {
      _loading = true;
    });

    await NotificationsListener.stopService();

    setState(() {
      started = false;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Notifier"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ConfigPage(),
                  ),
                ).then((value) => setState(() {}));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          ValueListenableBuilder<AppNotifierState?>(
            valueListenable: AppNotifierState.instance,
            builder: (BuildContext context, AppNotifierState? value, Widget? child) {
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Текущий хост:",
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          value?.host ?? "Не выбран",
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Текущий пост:",
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          "${value?.post ?? "Не выбран"}",
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _totalNotificationHandled,
            builder: (BuildContext context, int value, Widget? child) {
              return Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text(
                      "Обработано уведомлений:",
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "$value",
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'Start/Stop sensing',
        child: _loading ? const Icon(Icons.close) : (started ? const Icon(Icons.stop) : const Icon(Icons.play_arrow)),
      ),
    );
  }
}
