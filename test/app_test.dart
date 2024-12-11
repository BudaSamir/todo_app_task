import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/app/data/models/task.dart';
import 'package:todo_app/app/data/services/storage/storage_repository.dart';
import 'package:todo_app/app/modules/home/controllers/home_controller.dart';

class TestTaskRepository {
  List<Task> readTasks() => [];
  void writeTasks(List<Task> tasks) {}
}

class MockTaskRepository extends Mock implements TaskRepository {}

void main() {
  late HomeController controller;
  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
    when(mockTaskRepository.readTasks()).thenReturn([]);
    controller = HomeController(mockTaskRepository);
  });

  group('HomeController', () {
    test('initializes tasks from repository', () {
      expect(controller.tasks, isEmpty);
      verify(mockTaskRepository.readTasks()).called(1);
    });

    test('addTask adds a new task', () {
      const task = Task(title: 'New Task', icon: 0, color: '');
      final result = controller.addTask(task);

      expect(result, true);
      expect(controller.tasks, contains(task));
    });

    test('addTask does not add duplicate tasks', () {
      const task = Task(title: 'Duplicate Task', icon: 0, color: '');
      controller.addTask(task);
      final result = controller.addTask(task);

      expect(result, false);
      expect(controller.tasks.length, 1);
    });

    test('deleteTask removes a task', () {
      const task = Task(title: 'Task to Delete', icon: 0, color: '');
      controller.addTask(task);

      controller.deleteTask(task);

      expect(controller.tasks, isNot(contains(task)));
    });

    test('updateTask updates a task with a new todo', () {
      const task = Task(title: 'Task with Todos', icon: 0, color: '');
      controller.addTask(task);

      final result = controller.updateTask(task, 'New Todo');

      expect(result, true);
      expect(controller.tasks.first.todos, isNotNull);
      expect(controller.tasks.first.todos!.first['title'], 'New Todo');
    });

    test('updateTask does not add duplicate todos', () {
      const task = Task(title: 'Task with Duplicate Todos', icon: 0, color: '');
      controller.addTask(task);
      controller.updateTask(task, 'Duplicate Todo');

      final result = controller.updateTask(task, 'Duplicate Todo');

      expect(result, false);
      expect(controller.tasks.first.todos!.length, 1);
    });

    test('addTodo adds a new doing todo', () {
      final result = controller.addTodo('New Doing Todo');

      expect(result, true);
      expect(controller.doingTodos.first['title'], 'New Doing Todo');
    });

    test('addTodo does not add duplicate todos', () {
      controller.addTodo('Duplicate Todo');
      final result = controller.addTodo('Duplicate Todo');

      expect(result, false);
      expect(controller.doingTodos.length, 1);
    });

    test('doneTodo moves a todo to doneTodos', () {
      controller.addTodo('Todo to Complete');
      controller.doneTodo('Todo to Complete');

      expect(
        controller.doneTodos
            .firstWhereOrNull((todo) => todo['title'] == 'Todo to Complete'),
        isNotNull,
      );
      expect(
        controller.doingTodos
            .firstWhereOrNull((todo) => todo['title'] == 'Todo to Complete'),
        isNull,
      );
    });

    test('isToDosEmpty returns true for tasks without todos', () {
      const task = Task(title: 'Empty Task', icon: 0, color: '');
      expect(controller.isToDosEmpty(task), true);
    });

    test('getTotalTask returns the correct total number of todos', () {
      const task1 = Task(title: 'Task 1', icon: 0, color: '', todos: [
        {'title': 'Todo 1', 'done': false},
      ]);
      const task2 = Task(title: 'Task 2', icon: 0, color: '', todos: [
        {'title': 'Todo 2', 'done': true},
        {'title': 'Todo 3', 'done': false},
      ]);

      controller.addTask(task1);
      controller.addTask(task2);

      expect(controller.getTotalTask(), 3);
    });

    test('getTotalDoneTask returns the correct number of completed todos', () {
      const task1 = Task(title: 'Task 1', icon: 0, color: '', todos: [
        {'title': 'Todo 1', 'done': false},
      ]);
      const task2 = Task(title: 'Task 2', icon: 0, color: '', todos: [
        {'title': 'Todo 2', 'done': true},
        {'title': 'Todo 3', 'done': true},
      ]);

      controller.addTask(task1);
      controller.addTask(task2);

      expect(controller.getTotalDoneTask(), 2);
    });
  });
}
