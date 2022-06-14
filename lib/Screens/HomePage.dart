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
    if ((event.packageName ?? "") == Constants.targetPackage) {
      //Оплата: _ T
      //var messageInfo = event.text ?? ""; //TODO: parse money
      // TODO: send money to post
      // AppNotifierState.instance.value.apiClient?.
    }
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    NotificationsListener.receivePort?.listen((evt) => {onData(evt)});
    startListening();
  }

  @override
  void initState() {
    initPlatformState();
    _initInstance();
    super.initState();
  }

  void _initInstance() async {
    AppNotifierState newInstance = AppNotifierState();
    await newInstance.Init();
    AppNotifierState.instance.value = newInstance;
  }

  void startListening() async {
    var hasPermission = await NotificationsListener.hasPermission;
    if (!(hasPermission ?? false)) {
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!(isR ?? false)) {
      await NotificationsListener.startService(
        foreground: true,
        title: "FlutterNotifier",
        description: "Мониторинг уведомлений активен",
      );
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<AppNotifierState?>(
            valueListenable: AppNotifierState.instance,
            builder: (BuildContext context, AppNotifierState? value, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Текущий хост: ${value?.host ?? "Не выбран"}",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "Текущий пост: ${value?.post ?? "Не выбран"}",
                    ),
                  ),
                ],
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _totalNotificationHandled,
            builder: (BuildContext context, int value, Widget? child) {
              return Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Обработано уведомлений: $value",
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: started
          ? null
          : FloatingActionButton(
              onPressed: startListening,
              tooltip: 'Начать мониторинг',
              child: const Icon(Icons.play_arrow),
            ),
    );
  }
}
