import 'package:flutter/material.dart';
import 'package:flutter_notifier/Models/notification_event_log.dart';
import 'package:flutter_notifier/Pages/config_page.dart';
import 'package:flutter_notifier/Widgets/notification_list_panel.dart';
import 'package:flutter_notifier/hive_helpers.dart';
import 'package:flutter_notifier/notifier_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> started = ValueNotifier(false);
  bool _restarting = false;

  Future<void> init() async {
    startListening();
  }

  @override
  void initState() {
    init();
    super.initState();
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
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
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
                ValueListenableBuilder<Box<dynamic>>(
                  valueListenable: Hive.box(hiveConfigBox).listenable(keys: [hostKey, postKey]),
                  builder: (BuildContext context, Box<dynamic> config, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Текущий хост:",
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: FittedBox(
                                alignment: Alignment.centerRight,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (config.get(hostKey)) ?? "Не выбран",
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
                              fit: FlexFit.tight,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Текущий пост:",
                                  style: textTheme.titleMedium,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (config.get(postTitleKey)) ?? "Не выбран",
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              fit: FlexFit.tight,
                              child: FittedBox(
                                alignment: Alignment.centerRight,
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (config.get(postKey)) ?? "Не выбран",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      fit: FlexFit.tight,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Мониторинг:",
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
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
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: FittedBox(
                        alignment: Alignment.centerRight,
                        fit: BoxFit.scaleDown,
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
                ValueListenableBuilder(
                  valueListenable: Hive.box(hiveLogsBox).listenable(),
                  builder: (BuildContext context, Box<dynamic> box, Widget? child) {
                    return Row(
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Обработано уведомлений:",
                            style: textTheme.titleMedium,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${box.get(notificationTotalKey)}",
                            style: textTheme.titleMedium,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Последние уведомления за 24 часа:",
                    style: textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              child: ValueListenableBuilder(
                valueListenable: Hive.box(hiveLogsBox).listenable(),
                builder: (BuildContext context, Box<dynamic> box, Widget? child) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: (box.get(logKey)).length,
                  itemBuilder: (BuildContext context, int index) => NotificationListPanel.fromNotificationEventLog((box.get(logKey)[index]) as NotificationEventLog),
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
