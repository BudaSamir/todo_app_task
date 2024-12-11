import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/models/task.dart';
import '../../../data/services/storage/storage_repository.dart';

class HomeController extends GetxController {
  HomeController(this._taskRepository);
  final TaskRepository _taskRepository;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController editeCtrl = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(_taskRepository.readTasks());
    ever(tasks, (_) => _taskRepository.writeTasks(tasks));
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    } else {
      tasks.add(task);
      return true;
    }
  }

  bool updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containsTodo(todos, title)) {
      return false;
    }

    var todo = {"title": title, "done": false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containsTodo(List todos, String title) {
    return todos.any((todo) => todo['title'] == title);
  }

  void deleteTask(Task task) {
    if (tasks.contains(task)) {
      tasks.remove(task);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
