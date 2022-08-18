import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/hive_helpers.dart';
import 'package:flutter_notifier/notifier_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:optimize_battery/optimize_battery.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  ValueNotifier<String> _scanRange = ValueNotifier("");

  TextEditingController pinCodeController = TextEditingController();

  ValueNotifier<String> _selectedHost = ValueNotifier("");

  Map<String, String> _postToTitle = {"": ""};

  ValueNotifier<String> _selectedPost = ValueNotifier<String>("");

  int _pos = 0;
  bool _canScan = true;
  bool _successAuth = false;

  bool _isBatteryOptimizationDisabled = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    var config = Hive.box(hiveConfigBox);

    _isBatteryOptimizationDisabled = await OptimizeBattery.isIgnoringBatteryOptimizations();

    if (config.get(hostKey, defaultValue: null) != null) {
      DefaultApi api = DefaultApi(
        ApiClient(
          basePath: config.get(hostKey),
        ),
      );
      final res = await api.status().timeout(const Duration(seconds: 5));

      _postToTitle = {"": ""};
      res?.stations.forEach((station) {
        if (station.hash != null) {
          _postToTitle[station.hash!] = station.name ?? "Unnamed station";
        }
      });

      api.apiClient.addDefaultHeader(
        "Pin",
        config.get(pinKey, defaultValue: ""),
      );
      final userInfo = await api.getUser();
      _successAuth = userInfo != null;
    }

    pinCodeController.text = config.get(pinKey, defaultValue: "");
    setState(() {
      _canScan = true;
    });
  }

  @override
  void dispose() {
    pinCodeController.dispose();
    super.dispose();
  }

  void _scanStable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.wifi) {
      return;
    }
    final info = NetworkInfo();

    _pos = 0;
    setState(() {
      _canScan = false;
    });

    String localIp = await info.getWifiIP() ?? "";

    if (localIp == "" && mounted) {
      setState(() {
        _canScan = true;
      });
      return;
    }

    var scanIP = localIp.substring(
      0,
      localIp.lastIndexOf('.'),
    );
    _scanRange.value = "$scanIP.[___]";

    var targets = List.generate(256, (index) {
      return "$scanIP.$index";
    }).where((element) => element != localIp);

    await Future.forEach(targets, (element) async {
      try {
        _pos++;

        DefaultApi api = DefaultApi(
          ApiClient(
            basePath: "http://$element:8020",
          ),
        );
        final res = await api.status().timeout(const Duration(milliseconds: 500));

        _postToTitle = {"": ""};
        res?.stations.forEach((station) {
          if (station.hash != null) {
            _postToTitle[station.hash!] = station.name ?? "Unnamed station";
          }
        });

        api.apiClient.addDefaultHeader(
          "Pin",
          pinCodeController.value.text,
        );
        final userInfo = await api.getUser();
        _successAuth = userInfo != null;

        if (res != null) {
          if (mounted) {
            setState(() {
              _selectedHost.value = "http://$element:8020";
              _canScan = true;
              _pos = 256;
            });
            return;
          }
        }
      } on ApiException catch (apiError) {
        if (apiError.code == HttpStatus.unauthorized) {
          _successAuth = false;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }
      setState(() {});
    });

    if (mounted) {
      setState(() {
        _canScan = true;
      });
    }
  }

  void _scanQuick() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.wifi) {
      return;
    }
    final info = NetworkInfo();

    _pos = 0;
    setState(() {
      _canScan = false;
    });

    String localIp = await info.getWifiIP() ?? "";
    if (localIp == "" && mounted) {
      setState(() {
        _canScan = true;
      });
      return;
    }

    var scanIP = localIp.substring(
      0,
      localIp.lastIndexOf('.'),
    );
    _scanRange.value = "$scanIP.[___]";

    var targets = List.generate(256, (index) {
      return "$scanIP.$index";
    }).where((element) => element != localIp);

    targets.forEach((element) async {
      try {
        _pos++;

        DefaultApi api = DefaultApi(
          ApiClient(
            basePath: "http://$element:8020",
          ),
        );
        final res = await api.status().timeout(const Duration(seconds: 1));

        _postToTitle = {"": ""};
        res?.stations.forEach((station) {
          if (station.hash != null) {
            _postToTitle[station.hash!] = station.name ?? "Unnamed station";
          }
        });

        api.apiClient.addDefaultHeader(
          "Pin",
          pinCodeController.value.text,
        );
        final userInfo = await api.getUser();
        _successAuth = userInfo != null;

        if (res != null) {
          if (mounted) {
            setState(() {
              _selectedHost.value = "http://$element:8020";
              _canScan = true;
              _pos = 256;
            });
            return;
          }
        }
      } on ApiException catch (apiError) {
        if (apiError.code == HttpStatus.unauthorized) {
          _successAuth = false;
        }
      } catch (e) {
        if (kDebugMode) print(e);
      }

      if (_pos >= 255) {
        _canScan = true;
      }
      setState(() {});
    });

    if (mounted) {
      setState(() {
        _canScan = true;
      });
    }
  }

  void _saveHost() {
    var config = Hive.box(hiveConfigBox);

    config.put(hostKey, _selectedHost.value);
    config.put(pinKey, pinCodeController.value.text);
    NotifierService.instance!.updateApiClient();
  }

  void _savePost() {
    var config = Hive.box(hiveConfigBox);
    config.put(postKey, _selectedPost.value);
    config.put(postTitleKey, _postToTitle[_selectedPost.value]);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Параметры"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ValueListenableBuilder<Box<dynamic>>(
              valueListenable: Hive.box(hiveConfigBox).listenable(keys: [hostKey]),
              builder: (BuildContext context, Box<dynamic> box, Widget? child) {
                return Row(
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
                          box.get(hostKey) ?? "Не выбран",
                          textAlign: TextAlign.left,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            ValueListenableBuilder<Box<dynamic>>(
              valueListenable: Hive.box(hiveConfigBox).listenable(keys: [postKey, postTitleKey]),
              builder: (BuildContext context, Box<dynamic> box, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          box.get(postTitleKey) ?? "Не выбран",
                          textAlign: TextAlign.left,
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
                          box.get(postKey) ?? "Не выбран",
                          textAlign: TextAlign.right,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "PIN:",
                      textAlign: TextAlign.left,
                      style: textTheme.titleMedium,
                    ),
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
            const Divider(),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Сканирование",
                style: textTheme.titleLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ElevatedButton(
                    onPressed: _canScan ? () => _scanQuick() : null,
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "БЫСТРОЕ",
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
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ElevatedButton(
                      onPressed: _canScan ? () => _scanStable() : null,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "СТАНДАРТНОЕ",
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Поиск:",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _scanRange,
                      builder: (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
                          textAlign: TextAlign.left,
                          style: textTheme.bodyMedium,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: _pos / 256,
              valueColor: const AlwaysStoppedAnimation(Colors.redAccent),
              backgroundColor: Colors.grey,
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Сервер:",
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _selectedHost,
                      builder: (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
                          textAlign: TextAlign.left,
                          style: textTheme.bodyMedium,
                        );
                      },
                    ),
                  ),
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
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(_successAuth ? "ВЫБРАТЬ" : "НЕ АВТОРИЗОВАН"),
                      ),
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
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Пост:",
                                style: textTheme.titleMedium,
                              ),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Запрет оптимизации работы батареи",
                style: textTheme.titleLarge,
              ),
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
                              OptimizeBattery.openBatteryOptimizationSettings();
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
          ],
        ),
      ),
    );
  }
}
