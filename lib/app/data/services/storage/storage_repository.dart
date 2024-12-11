import '../../models/task.dart';
import '../../providers/task_provider.dart';

class TaskRepository {
  final TaskProvider taskProvider;

  const TaskRepository(this.taskProvider);

  List<Task> readTasks() => taskProvider.readTasks();

  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}
