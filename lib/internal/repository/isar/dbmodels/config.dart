import 'package:isar/isar.dart';

part 'config.g.dart';

@collection
class Config {
  final Id id = 1;
  String? host;
  int? port;
  int? pin;
  String? hash;
  String? title;

  Config({this.host, this.port, this.hash, this.title, this.pin});
}
