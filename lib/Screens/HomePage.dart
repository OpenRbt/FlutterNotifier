import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';
import 'package:flutter_notifier/Constants.dart';
import 'package:flutter_notifier/NotifierService.dart';
import 'package:flutter_notifier/Screens/ConfigPage.dart';
import 'package:flutter_notifier/Widgets/NotificationListPanel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> started = ValueNotifier(false);
  bool _restarting = false;
  ValueNotifier<int> _totalNotificationHandled = ValueNotifier(0);

  ValueNotifier<List<NotificationListPanel>> notifications = ValueNotifier([]);

  void onData(NotificationEvent event) {
    // if ((event.packageName ?? "") != Constants.targetPackage) return;

    _totalNotificationHandled.value = _totalNotificationHandled.value + 1;
    var lastProcessedEvent = NotifierService.lastEvents.last;
    notifications.value.add(
      NotificationListPanel(
        notificationEvent: lastProcessedEvent.event,
        Success: lastProcessedEvent.Success,
        Amount: lastProcessedEvent.Amount,
        TargetPost: lastProcessedEvent.TargetPost,
        TargetPostHash: lastProcessedEvent.TargetHash,
      ),
    );
    notifications.notifyListeners();
  }

  Future<void> init() async {
    if (NotifierService.instance == null) {
      await NotifierService.init();
    }
    NotifierService.instance?.Port.listen((evt) => onData(evt));
    startListening();
  }

  @override
  void initState() {
    init();
    if (NotifierService.lastEvents.isNotEmpty) loadEventsInfo();
    super.initState();
  }

  Future<void> loadEventsInfo() async {
    for (var event in NotifierService.lastEvents) {
      notifications.value.add(
        NotificationListPanel(
          notificationEvent: event.event,
          Success: event.Success,
          Amount: event.Amount,
          TargetPost: event.TargetPost,
          TargetPostHash: event.TargetHash,
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> startListening() async {
    started.value = await NotifierService.startService();
    if (mounted) setState(() => {_restarting = false});
  }

  Future<void> stopListening() async {
    started.value = !(await NotifierService.stopService());
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
              ).then((value) => AppNotifierState.instance.notifyListeners());
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
                          child: ValueListenableBuilder(
                            valueListenable: started,
                            builder: (BuildContext context, bool value, Widget? tmp) {
                              return Icon(
                                Icons.circle,
                                color: value ? Colors.green : Colors.red,
                              );
                            },
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
