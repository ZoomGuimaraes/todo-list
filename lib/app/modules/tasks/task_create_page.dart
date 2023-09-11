import 'package:flutter/material.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/theme_extensions.dart';
import 'package:todo_list/app/core/widget/todo_list_fild.dart';
import 'package:todo_list/app/modules/tasks/task_create_controller.dart';
import 'package:todo_list/app/modules/tasks/widgets/calendar_button.dart';
import 'package:validatorless/validatorless.dart';

class TaskCreatePage extends StatefulWidget {
  final TaskCreateController _controller;

  const TaskCreatePage({Key? key, required TaskCreateController controller})
      : _controller = controller,
        super(key: key);

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _descriptionEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._controller).listener(
        context: context,
        succesCallback: ((notifier, listenerInstance) {
          listenerInstance.dispose(); // Destruir porque não vou precisar dele
          Navigator.of(context).pop();
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEC;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final formValid = _formKey.currentState?.validate() ?? false;
            if (formValid) {
              widget._controller.save(_descriptionEC.text);
            }
          },
          backgroundColor: context.primaryColor,
          label: const Text(
            'Salvar Task',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Criar Atividade',
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 30),
              TodoListFild(
                  label: '',
                  controller: _descriptionEC,
                  validator: Validatorless.required('Descrição obrigatória')),
              const SizedBox(height: 20),
              CalendarButton(),
            ],
          ),
        ),
      ),
    );
  }
}
