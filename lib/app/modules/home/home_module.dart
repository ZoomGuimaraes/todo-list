import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/modules/todo_list_module.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

import '../../repositories/tasks/tasks_repository.dart';
import '../../repositories/tasks/tasks_repository_impel.dart';
import '../../services/tasks/tasks_service.dart';
import '../../services/tasks/tasks_service_impel.dart';
import 'home_page.dart';

class HomeModule extends TodoListModule {
  HomeModule()
      : super(
          bindings: [
            Provider<TasksRepository>(
              create: (context) =>
                  TasksRepositoryImpel(sqliteConnectionFactory: context.read()),
            ),
            Provider<TasksService>(
              create: (context) =>
                  TasksServiceImpel(tasksRepository: context.read()),
            ),
            ChangeNotifierProvider(
              create: (context) => HomeController(tasksService: context.read()),
            )
          ],
          routers: {
            '/home': (context) => HomePage(homeController: context.read()),
          },
        );
}
