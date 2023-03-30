import 'package:isar/isar.dart';

part 'status.g.dart';

@collection
class Status {
  final Id id = 1;
  bool? apiOk;
  bool? permissionStatus;

  Status({this.apiOk, this.permissionStatus});
}
