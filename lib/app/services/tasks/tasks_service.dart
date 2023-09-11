import 'package:todo_list/app/models/task_model.dart';

import '../../models/week_task_model.dart';

abstract class TasksService {
  Future<void> save(DateTime date, String description);
  Future<List<TaskModel>> getToDay();
  Future<List<TaskModel>> getTomorrow();
  Future<WeekTaskModel> getWeek();
  Future<void> checkOrUnchekTask(TaskModel task);
}
