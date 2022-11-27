import 'package:hive/hive.dart';
part 'projects.g.dart';

@HiveType(typeId: 0)
class Projects extends HiveObject {
  @HiveField(0)
  late String projectName;
  @HiveField(1)
  late String projectPath;
  @HiveField(2)
  late bool isActive;
}
