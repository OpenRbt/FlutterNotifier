import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/Constants.dart';
import 'package:flutter_notifier/Screens/ConfigPage.dart';
import 'package:flutter_notifier/Widgets/NotificationListPanel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool started = false;
  bool _loading = false;

  ValueNotifier<int> _totalNotificationHandled = ValueNotifier(0);

  ValueNotifier<List<NotificationListPanel>> notifications = ValueNotifier([
    // NotificationListPanel(
    //   notificationEvent: NotificationEvent(text: "Оплата: 100₸", title: "Пример уведомления"),
    //   Success: true,
    //   Amount: 100,
    //   TargetPost: "TestPost",
    //   TargetPostHash: "00:00:00:00:00",
    // )
  ]);

  void onData(NotificationEvent event) {
    if (event.packageName == Constants.targetPackage) {
      ProcessPost(event);
    }
  }

  final extractRegex = RegExp(r"-?((\d+\s?)+)\s?₸");
  final extractCleanRegex = RegExp(r"\s|₸");

  int extractAmountFromMessage(String message) {
    if (!message.contains("Оплата:")) return 0;

    var cleaned = extractRegex.stringMatch(message)?.replaceAll(extractCleanRegex, "") ?? "";
    var res = int.tryParse(cleaned) ?? 0;

    return res < 0 ? 0 : res;
  }

  void ProcessPost(NotificationEvent event) {
    if ((event.packageName ?? "") == Constants.targetPackage) {
      _totalNotificationHandled.value = _totalNotificationHandled.value + 1;

      var state = AppNotifierState.instance.value;

      var amount = extractAmountFromMessage(event.text ?? "");
      try {
        state?.apiClient.addServiceAmount(
          ArgAddServiceAmount(
            hash: state.post_id,
            amount: extractAmountFromMessage(event.text ?? ""),
          ),
        );

        notifications.value = List.from(
          notifications.value.length > 100 ? notifications.value.skip(1) : notifications.value,
        )..add(
            NotificationListPanel(
              notificationEvent: event,
              Success: true,
              Amount: amount,
              TargetPost: state?.post,
              TargetPostHash: state?.post_id,
            ),
          );
      } catch (e) {
        notifications.value = List.from(
          notifications.value.length > 100 ? notifications.value.skip(1) : notifications.value,
        )..add(
            NotificationListPanel(
              notificationEvent: event,
              Success: false,
              Amount: amount,
              TargetPost: state?.post,
              TargetPostHash: state?.post_id,
            ),
          );
      }
    }
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    NotificationsListener.receivePort?.listen((evt) => {onData(evt)});
    startListening();
  }

  @override
  void initState() {
    _initInstance();
    initPlatformState();
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
                  builder: (BuildContext context) => const ConfigPage(),
                ),
              ).then((value) => setState(() {}));
            },
            icon: const Icon(Icons.settings),
          )
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
          ),
          Divider(),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              child: ValueListenableBuilder(
                valueListenable: notifications,
                builder: (BuildContext context, List<NotificationListPanel> list, Widget? child) => ListView.builder(
                  itemCount: notifications.value.length,
                  itemBuilder: (BuildContext context, int index) => notifications.value[index],
                ),
              ),
            ),
          ),
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
