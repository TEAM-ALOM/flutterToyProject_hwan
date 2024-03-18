import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class ToDo extends HiveObject {
  ToDo({
    required this.task,
  });

  @HiveField(0)
  String task;
}
