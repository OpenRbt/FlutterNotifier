import 'package:flutter/material.dart';
import 'package:flutter_notifier/application/application.dart';

import 'notifier_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiChecker.init();

  runApp(Application());
}
