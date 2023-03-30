import 'package:flutter/material.dart';
import 'package:flutter_notifier/internal/Pages/home_page.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notifier',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const HomePage(),
    );
  }
}
