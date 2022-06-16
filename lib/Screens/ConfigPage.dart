import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notifier/ApiClient/api.dart';
import 'package:flutter_notifier/Constants.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);
  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  SharedPreferences? _sharedPreferences;

  ValueNotifier<String> _scanRange = ValueNotifier("");
  ValueNotifier<String?> _host = ValueNotifier(null);
  ValueNotifier<String?> _post = ValueNotifier(null);
  ValueNotifier<String?> _postTitle = ValueNotifier(null);

  TextEditingController pinCodeController = TextEditingController();

  String _selectedHost = "";
  List<String> _possiblePostsTitle = [];
  List<String> _possiblePostsValue = [];
  String _selectedPost = "";

  int _pos = 0;
  bool _canScan = true;

  bool _succesAuth = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _host.value = _sharedPreferences?.getString(Constants.hostKey);
    _post.value = _sharedPreferences?.getString(Constants.postKey);
    _postTitle.value = _sharedPreferences?.getString(Constants.postTitleKey);

    var pin = _sharedPreferences?.getString(Constants.pinKey);

    setState(() {
      _selectedHost = _host.value ?? "";
      _selectedPost = _post.value ?? "";
      pinCodeController.text = pin ?? "";
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
    _scanRange.value = "${scanIP}.[___]";

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

        var stations = (res?.stations.where((element) => element.hash != null).toList() ?? []);
        if (res != null) {
          if (stations.isNotEmpty) {
            _possiblePostsTitle = List.generate(stations.length, (index) => stations[index].name ?? "");
            _possiblePostsValue = List.generate(stations.length, (index) => stations[index].hash ?? "");
            if (!_possiblePostsValue.contains(_selectedPost)) {
              _selectedPost = _possiblePostsValue.first;
            }
          } else {
            _possiblePostsTitle = [];
            _possiblePostsValue = [];
            _selectedPost = "";
          }

          _selectedHost = "http://$element:8020";
          api.apiClient.addDefaultHeader(
            "Pin",
            pinCodeController.value.text,
          );
          final userInfo = await api.getUser();
          _succesAuth = userInfo != null;

          if (mounted) {
            setState(() {
              _canScan = true;
              _pos = 256;
            });
            return;
          }
        }
      } on ApiException catch (apiError) {
        if (apiError.code == HttpStatus.unauthorized) {
          _succesAuth = false;
        }
      } catch (e) {
        // print(e);
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
    _scanRange.value = "${scanIP}.[___]";

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

        var stations = (res?.stations.where((element) => element.hash != null).toList() ?? []);
        if (res != null) {
          if (stations.isNotEmpty) {
            _possiblePostsTitle = List.generate(stations.length, (index) => stations[index].name ?? "");
            _possiblePostsValue = List.generate(stations.length, (index) => stations[index].hash ?? "");
            if (!_possiblePostsValue.contains(_selectedPost)) {
              _selectedPost = _possiblePostsValue.first;
            }
          } else {
            _possiblePostsTitle = [];
            _possiblePostsValue = [];
            _selectedPost = "";
          }

          _selectedHost = "http://$element:8020";
          api.apiClient.addDefaultHeader(
            "Pin",
            pinCodeController.value.text,
          );
          final userInfo = await api.getUser();
          _succesAuth = userInfo != null;
        }
      } on ApiException catch (apiError) {
        if (apiError.code == HttpStatus.unauthorized) {
          _succesAuth = false;
        }
      } catch (e) {
        // print(e);
      }

      if (_pos == 255) {
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
    if (_succesAuth) {
      _sharedPreferences?.setString(Constants.hostKey, _selectedHost);
      _sharedPreferences?.setString(Constants.pinKey, pinCodeController.value.text);
      _host.value = _selectedHost;
    }
    _updateInstance();
  }

  void _savePost() {
    var title = "";
    for (int i = 0; i < _possiblePostsTitle.length; i++) {
      if (_possiblePostsValue[i] == _selectedPost) {
        title = _possiblePostsTitle[i];
        break;
      }
    }

    _sharedPreferences?.setString(Constants.postTitleKey, title);
    _sharedPreferences?.setString(Constants.postKey, _selectedPost);
    _post.value = _selectedPost;
    _postTitle.value = title;

    _updateInstance();
  }

  void _updateInstance() async {
    AppNotifierState newInstance = AppNotifierState();
    await newInstance.Init();
    AppNotifierState.instance.value = newInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Параметры"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Text(
                      "Текущий хост:",
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _host,
                      builder: (BuildContext context, String? value, Widget? child) {
                        return Text(
                          value ?? "Не выбран",
                          textAlign: TextAlign.left,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Text(
                      "Текущий пост:",
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _postTitle,
                      builder: (BuildContext context, String? value, Widget? child) {
                        return Container(
                          child: Text(
                            value ?? "Не выбран",
                            textAlign: TextAlign.left,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _post,
                      builder: (BuildContext context, String? value, Widget? child) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            value ?? "Не выбран",
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      "PIN:",
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    width: double.maxFinite,
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
                          color: (_succesAuth && _canScan) ? Colors.green : Colors.red,
                        ),
                        hintText: "Введите пин...",
                        helperText: "Пин-код авторизации",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: _canScan ? () => _scanQuick() : null,
                      child: const Text("Быстрое сканирование"),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: _canScan ? () => _scanStable() : null,
                      child: const Text("Cканирование"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Text(
                      "Поиск:",
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: ValueListenableBuilder<String>(
                      valueListenable: _scanRange,
                      builder: (BuildContext context, String value, Widget? child) {
                        return Text(
                          value,
                          textAlign: TextAlign.left,
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
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Text(
                      "Сервер: ",
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    height: 30,
                    child: Text(
                      _selectedHost,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: (_succesAuth && _canScan) ? _saveHost : null,
                      child: Text(_succesAuth ? "Сохранить" : "Авторизация не пройдена"),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Text("Пост: "),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                      width: double.maxFinite,
                      child: _possiblePostsValue.isNotEmpty
                          ? DropdownButton<String>(
                              items: List.generate(
                                _possiblePostsTitle.length,
                                (index) => DropdownMenuItem(
                                  value: _possiblePostsValue[index],
                                  child: Text(
                                    _possiblePostsTitle[index],
                                  ),
                                ),
                              ),
                              onChanged: (newValue) {
                                setState(() => {_selectedPost = newValue ?? ""});
                              },
                              value: _selectedPost,
                              isExpanded: true,
                            )
                          : Text("Нет доступных постов")),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    width: double.maxFinite,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: _possiblePostsTitle.isNotEmpty ? _savePost : null,
                      child: Text(
                        _possiblePostsTitle.isNotEmpty ? "Сохранить пост" : "Нечего сохранять",
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
