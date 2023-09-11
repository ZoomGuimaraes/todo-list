import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class Task extends StatelessWidget {
  final TaskModel model;
  final dateFormat = DateFormat('dd/MM/y');
  Task({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: const [BoxShadow(color: Colors.grey)],
        border: Border.all(width: 2, color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        // contentPadding: const EdgeInsets.all(8),
        contentPadding:
            const EdgeInsets.only(top: 2, bottom: 8, left: 8, right: 8),
        leading: Checkbox(
          value: model.finished,
          onChanged: (value) =>
              context.read<HomeController>().checkOrUncheckTask(model),
        ),
        title: Text(
          model.description,
          style: TextStyle(
            decoration: model.finished ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          dateFormat.format(model.dateTime),
          style: TextStyle(
            decoration: model.finished ? TextDecoration.lineThrough : null,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(width: 1),
        ),
      ),
    );
  }
}
