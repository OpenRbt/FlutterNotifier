import 'package:flutter/material.dart';
import 'package:flutter_notifier/internal/Pages/config_page.dart';
import 'package:flutter_notifier/internal/Widgets/notification_list_panel.dart';
import 'package:flutter_notifier/internal/entity/entity.dart' as entity;
import 'package:flutter_notifier/internal/repository/isar/dbmodels/config.dart';
import 'package:flutter_notifier/internal/repository/isar/dbmodels/notification_event.dart';
import 'package:flutter_notifier/internal/repository/isar/dbmodels/status.dart';
import 'package:flutter_notifier/internal/repository/isar/repository.dart';
import 'package:flutter_notifier/notifier_service.dart';
import 'package:notification_listener_service/notification_listener_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final IsarRepository _repo = IsarRepository();

  ValueNotifier<bool> started = ValueNotifier(false);

  Future<void> init() async {
    _repo.init();
  }

  @override
  void initState() {
    init();
    super.initState();
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
                  builder: (BuildContext context) => ConfigPage(
                    repo: _repo,
                  ),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                    stream: _repo.isar!.configs.watchLazy(),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return FutureBuilder<dynamic>(
                        future: _repo.getConfig(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          final config = snapshot.data as entity.Config?;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Текущий хост: ${config?.host ?? "Не выбран"}",
                                style: textTheme.titleMedium,
                              ),
                              //TODO: add post title
                              Text(
                                "Текущий пост: ${config?.title?.toString() ?? "Не выбран"} / ${config?.hash ?? ""}",
                                style: textTheme.titleMedium,
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  FutureBuilder(
                    future: NotificationListenerService.isPermissionGranted(),
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Доступ к уведомлениям: ",
                                style: textTheme.titleMedium,
                              ),
                              Icon(
                                Icons.circle,
                                color: (snapshot.data ?? false) ? Colors.green : Colors.red,
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: () async {
                                var status = await NotificationListenerService.isPermissionGranted();
                                if (!status) {
                                  status = await NotificationListenerService.requestPermission();
                                  // ApiChecker.service.invoke("stopService");
                                  // ApiChecker.service.invoke("startService");
                                  setState(() {});
                                }
                              },
                              child: const Text("Получить доступ"))
                        ],
                      );
                    },
                  ),
                  FutureBuilder(
                    future: ApiChecker.service.isRunning(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Статус сервиса: ",
                                style: textTheme.titleMedium,
                              ),
                              Icon(
                                Icons.circle,
                                color: (snapshot.data ?? false) ? Colors.green : Colors.red,
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: _repo.isar!.status.watchLazy(),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return FutureBuilder<dynamic>(
                        future: _repo.getStatus(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          final status = snapshot.data as entity.Status?;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Статус API:",
                                    style: textTheme.titleMedium,
                                  ),
                                  status != null
                                      ? Icon(
                                          Icons.circle,
                                          color: (status.apiOk ?? false) ? Colors.green : Colors.red,
                                        )
                                      : const CircularProgressIndicator(),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder(
                    stream: _repo.isar!.notificationEvents.watchLazy(),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      return FutureBuilder(
                        future: _repo.isar!.notificationEvents.count(),
                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                          return Text(
                            "Обработано уведомлений: ${snapshot.data ?? 0}",
                            style: textTheme.titleMedium,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _repo.isar!.notificationEvents.watchLazy(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                return FutureBuilder(
                  future: _repo.isar!.notificationEvents.count(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) => NotificationListPanel.fromNotificationEvent(_repo.getEventSync(((snapshot.data ?? 0) - index))!),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
