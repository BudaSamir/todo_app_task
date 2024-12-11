import 'dart:convert';

import 'package:get/get.dart';
import 'package:todo_app/app/core/utils/keys.dart';
import 'package:todo_app/app/data/models/task.dart';
import 'package:todo_app/app/data/services/storage/storage_service.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    List<Task> tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((json) => tasks.add(Task.fromJson(json)));
    return tasks;
  }

  // void writeTasks(List<Task> tasks) =>
  //     _storage.write(taskKey, jsonEncode(tasks));

  void writeTasks(List<Task> tasks) => _storage.write(
      taskKey, jsonEncode(tasks.map((task) => task.toJson()).toList()));
}
