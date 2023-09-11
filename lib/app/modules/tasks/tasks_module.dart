import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/todo_list_module.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/task_create_page.dart';
import 'package:todo_list/app/repositories/tasks/tasks_repository_impel.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';
import 'package:todo_list/app/services/tasks/tasks_service_impel.dart';

import '../../repositories/tasks/tasks_repository.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(bindings: [
          Provider<TasksRepository>(
            create: (context) =>
                TasksRepositoryImpel(sqliteConnectionFactory: context.read()),
          ),
          Provider<TasksService>(
            create: (context) =>
                TasksServiceImpel(tasksRepository: context.read()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                TaskCreateController(tasksService: context.read()),
          )
        ], routers: {
          '/task/create': (context) =>
              TaskCreatePage(controller: context.read()),
        });
}
