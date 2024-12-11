import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/models/task.dart';
import '../../../data/services/storage/storage_repository.dart';

class HomeController extends GetxController {
  HomeController(this._taskRepository);
  final TaskRepository _taskRepository;
  final formKey = GlobalKey<FormState>();
  final editeCtrl = TextEditingController();
  final tabIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(_taskRepository.readTasks());
    ever(tasks, (_) => _taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    super.onClose();
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

  void changeTabIndex(int index) {
    tabIndex.value = index;
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

  bool addTodo(String title) {
    var doingTodo = {"title": title, "done": false};
    if (doingTodos.any((e) => mapEquals(doingTodo, e))) {
      return false;
    }
    var doneTodo = {"title": title, "done": true};
    if (doneTodos.any((e) => mapEquals(doneTodo, e))) {
      return false;
    }
    doingTodos.add(doingTodo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([...doingTodos, ...doneTodos]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  void doneTodo(String title) {
    var doingTodo = {"title": title, "done": false};
    int index =
        doingTodos.indexWhere((element) => mapEquals(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {"title": title, "done": true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneToDo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));

    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isToDosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
