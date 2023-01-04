import 'package:hive/hive.dart';
part 'active.g.dart';

@HiveType(typeId: 0)
class Active extends HiveObject {
  @HiveField(0)
  late String active;
}
