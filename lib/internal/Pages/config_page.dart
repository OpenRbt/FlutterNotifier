import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/internal/entity/entity.dart' as entity;
import 'package:flutter_notifier/internal/repository/isar/dbmodels/config.dart';
import 'package:flutter_notifier/internal/repository/isar/repository.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:optimize_battery/optimize_battery.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key, required this.repo}) : super(key: key);

  final IsarRepository repo;

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  TextEditingController pinCodeController = TextEditingController();

  final ValueNotifier<String> _selectedHost = ValueNotifier("");

  Map<String, String> _postToTitle = {"": ""};

  final ValueNotifier<String> _selectedPost = ValueNotifier<String>("");

  TextEditingController subnetTextController = TextEditingController();

  bool _canScan = true;
  bool _successAuth = false;

  bool _isBatteryOptimizationDisabled = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    var config = await widget.repo.getConfig();

    _isBatteryOptimizationDisabled = await OptimizeBattery.isIgnoringBatteryOptimizations();

    if (config != null) {
      if (config.host != null) {
        DefaultApi api = DefaultApi(
          ApiClient(
            basePath: "http://${config.host!}",
          ),
        );
        final res = await api.status().timeout(const Duration(seconds: 5));

        _postToTitle = {"": ""};
        if (res != null) {
          for (var station in res.stations) {
            if (station.hash != null && station.id != null) {
              _postToTitle[station.hash!] = station.name ?? "Unnamed station";
            }
          }
        }

        api.apiClient.addDefaultHeader(
          "Pin",
          config.pin?.toString() ?? "",
        );
        final userInfo = await api.getUser();
        _successAuth = userInfo != null;
      }
    }

    pinCodeController.text = config?.pin?.toString() ?? "";
    setState(() {
      _canScan = true;
    });
  }

  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  void _scanHost() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.wifi) {
      return;
    }
    if (subnetTextController.text.isNotEmpty) {
      var host = subnetTextController.text;

      DefaultApi api = DefaultApi(
        ApiClient(
          basePath: "http://$host",
        ),
      );

      await api.getPing();
      final res = await api.status();
      _postToTitle = {"": ""};

      api.apiClient.addDefaultHeader(
        "Pin",
        pinCodeController.value.text,
      );

      var userInfo = await api.getUser();
      _successAuth = userInfo != null;

      if (res != null) {
        for (var station in res.stations) {
          if (station.hash != null) {
            _postToTitle[station.hash!] = station.name ?? "Unnamed station";
          }
        }
      }

      setState(() {
        _selectedHost.value = "http://$host";
        _canScan = true;
      });
    }
  }

  void _scanStable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.wifi) {
      return;
    }
    final info = NetworkInfo();
    var lanBroadcast = await info.getWifiBroadcast();
    var lanGateway = await info.getWifiGatewayIP();
    String localIP = await info.getWifiIP() ?? "";
    var client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: 500);

    var scanIP = localIP.substring(
      0,
      localIP.lastIndexOf('.'),
    );

    var subIPS = List.generate(255, (index) {
      return "$scanIP.${index + 1}";
    });

    subIPS.remove(lanBroadcast!);
    subIPS.remove(lanGateway!);
    subIPS.remove(localIP);

    // setState(() {
    //   _canScan = false;
    // });
    //
    // Future.forEach(subIPS, (String element) async {
    //   try {
    //     final request = await client.get(element, 8020, "/ping");
    //     final response = await request.close();
    //
    //     if (response.statusCode == 200) {
    //       DefaultApi api = DefaultApi(
    //         ApiClient(
    //           basePath: "http://$element:8020",
    //         ),
    //       );
    //
    //       final res = await api.status();
    //       _postToTitle = {"": ""};
    //       if (res != null) {
    //         for (var station in res.stations) {
    //           if (station.hash != null) {
    //             _postToTitle[station.hash!] = station.name ?? "Unnamed station";
    //           }
    //         }
    //       }
    //       _selectedHost.value = "$element:8020";
    //
    //       api.apiClient.addDefaultHeader(
    //         "Pin",
    //         pinCodeController.value.text,
    //       );
    //
    //       final user = await api.getUser();
    //       setState(
    //         () {
    //           _successAuth = false;
    //         },
    //       );
    //     }
    //   } catch (error) {
    //     log(error.toString());
    //   }
    // });
    //
    // setState(() {
    //   _canScan = true;
    // });
    // return;
    for (final element in subIPS) {
      client.get(element, 8020, "/ping").then(
          (request) => request.close().then((response) {
                if (response.statusCode == 200) {
                  DefaultApi api = DefaultApi(
                    ApiClient(
                      basePath: "http://$element:8020",
                    ),
                  );
                  api.status().timeout(const Duration(seconds: 3)).then(
                    (res) {
                      _postToTitle = {"": ""};
                      if (res != null) {
                        for (var station in res.stations) {
                          if (station.hash != null) {
                            _postToTitle[station.hash!] = station.name ?? "Unnamed station";
                          }
                        }
                      }

                      api.apiClient.addDefaultHeader(
                        "Pin",
                        pinCodeController.value.text,
                      );
                      api.getUser().then(
                        (userInfo) {
                          setState(() {
                            _successAuth = userInfo != null;
                          });
                        },
                        onError: (e) => setState(
                          () {
                            _successAuth = false;
                          },
                        ),
                      );

                      _selectedHost.value = "$element:8020";
                    },
                  );
                }
              }, onError: (error) {
                log(error.toString());
              }), onError: (error) {
        log(error.toString());
      });
    }
  }

  void _saveHost() async {
    var config = await widget.repo.getConfig();
    config ??= entity.Config();

    config.host = _selectedHost.value;
    config.pin = int.parse(pinCodeController.value.text);
    await widget.repo.updateConfig(config);

    // var logBox = Hive.box(hiveLogsBox);
    // logBox.put(washStatusKey, true);
    // NotifierService.updateApiClient();
  }

  void _savePost() async {
    var config = await widget.repo.getConfig();
    config ??= entity.Config();

    config.hash = _selectedPost.value;
    config.title = _postToTitle[_selectedPost.value];

    await widget.repo.updateConfig(config);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Параметры"),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8),
        children: [
          StreamBuilder<dynamic>(
            stream: widget.repo.isar!.configs.watchLazy(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return FutureBuilder(
                future: widget.repo.getConfig(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  final config = snapshot.data as entity.Config?;
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Текущий хост: ${config?.host ?? "Не выбран"}",
                            style: textTheme.titleMedium,
                          ),
                          Text(
                            "Текущий пост: ${config?.title?.toString() ?? "Не выбран"}",
                            style: textTheme.titleMedium,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  "PIN:",
                                  textAlign: TextAlign.left,
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextField(
                                  controller: pinCodeController,
                                  maxLines: 1,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  obscuringCharacter: "*",
                                  enableInteractiveSelection: false,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.security,
                                      color: (_successAuth && _canScan) ? Colors.green : Colors.red,
                                    ),
                                    hintText: "Введите пин...",
                                    helperText: "Пин-код авторизации",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Text(
                                  "Хост:",
                                  textAlign: TextAlign.left,
                                  style: textTheme.titleMedium,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: TextField(
                                  controller: subnetTextController,
                                  maxLines: 1,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  obscuringCharacter: "*",
                                  enableInteractiveSelection: false,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.:]"))],
                                  decoration: InputDecoration(
                                    icon: Icon(
                                      Icons.wifi,
                                      color: (_successAuth && _canScan) ? Colors.green : Colors.red,
                                    ),
                                    hintText: "Введите IP хоста...",
                                    helperText: "Пример 192.168.0.123:8020"
                                        "",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Text(
            "Сканирование",
            style: textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _canScan ? () => _scanStable() : null,
                child: const Text(
                  "СКАНИРОВАТЬ",
                ),
              ),
              TextButton(
                onPressed: _canScan ? () => _scanHost() : null,
                child: const Text(
                  "СКАНИРОВАТЬ ХОСТ",
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: _selectedHost,
                builder: (BuildContext context, String value, Widget? child) {
                  return Text(
                    "Сервер: $value",
                    textAlign: TextAlign.left,
                    style: textTheme.bodyMedium,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: (_successAuth && _canScan) ? _saveHost : null,
                    child: Text(_successAuth ? "ВЫБРАТЬ" : "НЕ АВТОРИЗОВАН"),
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: _selectedPost,
              builder: (BuildContext context, String value, Widget? child) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Text(
                            "Пост:",
                            style: textTheme.titleMedium,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: DropdownButton<String>(
                              items: _postToTitle.entries
                                  .map(
                                    (entry) => DropdownMenuItem<String>(
                                      value: entry.value,
                                      child: Text(entry.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (newValue) {
                                for (var key in _postToTitle.keys) {
                                  if (_postToTitle[key] == newValue) {
                                    _selectedPost.value = key;
                                    return;
                                  }
                                }
                              },
                              value: _postToTitle[_selectedPost.value],
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(
                          flex: 1,
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: SizedBox(
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: _selectedPost.value.isNotEmpty ? _savePost : null,
                              child: const Text(
                                "ВЫБРАТЬ",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          const Divider(),
          Text(
            "Запрет оптимизации работы батареи",
            style: textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: ElevatedButton.icon(
                  onPressed: _isBatteryOptimizationDisabled
                      ? null
                      : () async {
                          bool disabledOptimisation = await OptimizeBattery.isIgnoringBatteryOptimizations();

                          if (!disabledOptimisation) {
                            disabledOptimisation = await OptimizeBattery.stopOptimizingBatteryUsage();
                          }
                          setState(() {
                            _isBatteryOptimizationDisabled = disabledOptimisation;
                          });
                        },
                  icon: const Icon(Icons.settings),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _isBatteryOptimizationDisabled ? "ОТКЛЮЧЕНА" : "ОТКЛЮЧИТЬ",
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    bool disabledOptimisation = await OptimizeBattery.isIgnoringBatteryOptimizations();

                    setState(() {
                      _isBatteryOptimizationDisabled = disabledOptimisation;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "СТАТУС",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Icon(Icons.info_outline),
                  Text("Дополнительно может понадобиться разрешить автозапуск приложения в настройках устройства, так как некоторые производители устанавливают иные стандартные параметры для лучшего энергосбережения."),
                  Text("Данные параметры могут повлиять на автоматический запуск сервиса после перезагузки устройтсва"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
