import 'dart:collection';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
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

  ValueNotifier<String?> _host = ValueNotifier(null);
  ValueNotifier<int?> _post = ValueNotifier(null);

  ValueNotifier<List<String>> _possibleHosts = ValueNotifier([""]);
  String _selectedHost = "";
  List<int> _possiblePosts = List.generate(12, (index) => index);
  int _selectedPost = 0;

  int _pos = 0;
  bool _canScan = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _host.value = _sharedPreferences?.getString(Constants.hostKey);
    _post.value = _sharedPreferences?.getInt(Constants.postKey);
    List<String> hosts = List.from([""])
      ..add("127.0.0.1")
      ..add("255.255.255.255")
      ..sort();

    setState(() {
      _possibleHosts.value = hosts;
      _selectedHost = "";
      _canScan = true;
    });
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

    HashSet<String> servers = HashSet();

    var client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: 100);

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

    var targets = List.generate(256, (index) {
      return "$scanIP.$index";
    }).where((element) => element != localIp);

    await Future.forEach(targets, (element) async {
      try {
        setState(() {
          _pos++;
        });

        final request = await client.get("$element", 8020, "/ping");
        final response = await request.close();
        if (response.statusCode == 200) {
          servers.add("$element");
        }
      } catch (e) {}
    });

    List<String> hosts = List.from(servers)
      ..add("")
      ..add("127.0.0.1")
      ..sort();

    if (mounted) {
      setState(() {
        _possibleHosts.value = hosts;
        _selectedHost = "";
        _canScan = true;
      });
    }
    client.close();
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

    HashSet<String> servers = HashSet();

    var client = HttpClient();
    client.connectionTimeout = const Duration(milliseconds: 100);

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

    var targets = List.generate(256, (index) {
      return "$scanIP.$index";
    }).where((element) => element != localIp);

    client.connectionTimeout = const Duration(seconds: 60);

    targets.forEach((element) async {
      try {
        final request = await client.get(element, 8020, "/ping");
        final response = await request.close();
        if (response.statusCode == 200) {
          servers.add("$scanIP.$element");
        }
      } catch (e) {
        print(e);
      }

      _pos++;
      if (_pos == 255) {
        _canScan = true;
      }
      setState(() {});
    });

    List<String> hosts = List.from(servers)
      ..add("")
      ..add("127.0.0.1")
      ..sort();

    if (mounted) {
      setState(() {
        _possibleHosts.value = hosts;
        _selectedHost = "";
        _canScan = true;
      });
    }
    client.close();
  }

  void _saveHost() {
    _sharedPreferences?.setString(Constants.hostKey, _selectedHost);
    _host.value = _selectedHost;
    _updateInstance();
  }

  void _savePost() {
    _sharedPreferences?.setInt(Constants.postKey, _selectedPost);
    _post.value = _selectedPost;
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
                Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    "Текущий хост:",
                  ),
                ),
                const Spacer(),
                ValueListenableBuilder<String?>(
                  valueListenable: _host,
                  builder: (BuildContext context, String? value, Widget? child) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        value ?? "Не выбран",
                      ),
                    );
                  },
                ),
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
                ValueListenableBuilder<int?>(
                  valueListenable: _post,
                  builder: (BuildContext context, int? value, Widget? child) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        "${value ?? "Не выбран"}",
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: _canScan ? () => _scanQuick() : null,
                      color: Colors.white,
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
                    child: MaterialButton(
                      onPressed: _canScan ? () => _scanStable() : null,
                      color: Colors.white,
                      child: const Text("Cканирование"),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: const Text("Сервер: "),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DropdownButton<String>(
                      items: _possibleHosts.value.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => {_selectedHost = newValue ?? ""});
                      },
                      value: _selectedHost,
                      isExpanded: true,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: double.maxFinite,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: _saveHost,
                      color: Colors.white,
                      child: const Text("Сохранить хост"),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: const Text("Пост: "),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: DropdownButton<int>(
                      items: _possiblePosts.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() => {_selectedPost = newValue ?? -1});
                      },
                      value: _selectedPost,
                      isExpanded: true,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 3,
                  child: Container(
                    width: double.maxFinite,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: _savePost,
                      color: Colors.white,
                      child: const Text("Сохранить пост"),
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
