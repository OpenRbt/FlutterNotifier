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
  bool _restarting = false;
  ValueNotifier<int> _totalNotificationHandled = ValueNotifier(0);

  ValueNotifier<List<NotificationListPanel>> notifications = ValueNotifier([]);

  void onData(NotificationEvent event) {
    if (event.packageName == Constants.targetPackage) {
      processPost(event);
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

  void processPost(NotificationEvent event) {
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
        notifications.value.add(
          NotificationListPanel(
            notificationEvent: event,
            Success: true,
            Amount: amount,
            TargetPost: state?.post,
            TargetPostHash: state?.post_id,
          ),
        );
        if (notifications.value.length > 100) {
          notifications.value.removeAt(0);
        }
      } catch (e) {
        notifications.value.add(
          NotificationListPanel(
            notificationEvent: event,
            Success: false,
            Amount: amount,
            TargetPost: state?.post,
            TargetPostHash: state?.post_id,
          ),
        );
        if (notifications.value.length > 100) {
          notifications.value.removeAt(0);
        }
      }
      notifications.notifyListeners();
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

  Future<void> startListening() async {
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

    setState(() => {started = true, _restarting = false});
  }

  Future<void> stopListening() async {
    await NotificationsListener.stopService();

    setState(() {
      started = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<AppNotifierState?>(
                  valueListenable: AppNotifierState.instance,
                  builder: (BuildContext context, AppNotifierState? value, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  "Текущий хост:",
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  value?.host ?? "Не выбран",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  "Текущий пост:",
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  value?.post ?? "Не выбран",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Text(
                          "Мониторинг уведомлений:",
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            color: started ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        width: double.maxFinite,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext ctx) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: const Text("Перезапустить сервис?"),
                                      content: Center(
                                        child: _restarting ? const CircularProgressIndicator() : null,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: _restarting
                                              ? null
                                              : () {
                                                  Navigator.of(context).pop();
                                                },
                                          child: const Text("НЕТ"),
                                        ),
                                        ElevatedButton(
                                          onPressed: _restarting
                                              ? null
                                              : () async {
                                                  _restarting = true;
                                                  setState(() {});
                                                  await stopListening();
                                                  await Future.delayed(const Duration(seconds: 3), () {});
                                                  await startListening();
                                                  setState(() {
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                          child: const Text("ДА"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            "ПЕРЕЗАПУСТИТЬ",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _totalNotificationHandled,
                  builder: (BuildContext context, int value, Widget? child) {
                    return Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "Обработано уведомлений:",
                              style: textTheme.titleMedium,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Text(
                              "$value",
                              style: textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
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
    );
  }
}
