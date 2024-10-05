// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_app/data/database/tasks_data_source.dart';
import 'package:todo_app/data/model/task_model.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.tasks,
    required this.deleteTask,
    required this.editTask,
  }) : super(key: key);
  final TaskModel tasks;
  final void Function() deleteTask;
  final void Function() editTask;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool isChecked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isChecked = widget.tasks.isDone!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                      activeColor: Colors.green,
                      value: isChecked,
                      onChanged: (newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                        TasksDataSource.toggleTask(widget.tasks);
                      }),
                  Text(
                    '${widget.tasks.taskTitle}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                        decoration:
                            isChecked ? TextDecoration.lineThrough : null),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  '${widget.tasks.date}',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.message,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '${widget.tasks.message}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: widget.editTask,
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: widget.deleteTask,
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
