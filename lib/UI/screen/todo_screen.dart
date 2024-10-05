import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/UI/widget/task_item.dart';
import 'package:todo_app/data/database/tasks_data_source.dart';
import 'package:todo_app/data/model/task_model.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController dateC = TextEditingController();
  final TextEditingController commentC = TextEditingController();
  List<TaskModel> tasks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      height: 300,
                      child: Column(
                        children: [
                          TextField(
                            controller: titleC,
                            decoration: const InputDecoration(
                                hintText: 'Title',
                                border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: dateC,
                            readOnly: true,
                            onTap: () async {
                              var date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2026));
                              var formatedDate = DateFormat.yMd().format(date!);
                              dateC.text = formatedDate.toString();
                            },
                            decoration: const InputDecoration(
                                hintText: 'date', border: OutlineInputBorder()),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: commentC,
                            decoration: const InputDecoration(
                                hintText: 'comment',
                                border: OutlineInputBorder()),
                          ),
                          const Spacer(),
                          ElevatedButton(
                              onPressed: () async {
                                TaskModel task = TaskModel(
                                    taskTitle: titleC.text,
                                    date: dateC.text,
                                    message: commentC.text);
                                await TasksDataSource.insertTask(task);
                                getTask();
                                Navigator.pop(context);
                                titleC.clear();
                                dateC.clear();
                                commentC.clear();
                              },
                              child: const Text('Save'))
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Todo"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          var currentItem = tasks[index];
          return TaskItem(
            tasks: currentItem,
            deleteTask: () async {
              setState(() {
                tasks.remove(currentItem);
              });
              await TasksDataSource.deleteTask(currentItem);
            },
            editTask: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          height: 300,
                          child: Column(
                            children: [
                              TextField(
                                controller: titleC,
                                decoration: const InputDecoration(
                                    hintText: 'Title',
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: dateC,
                                readOnly: true,
                                onTap: () async {
                                  var date = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime(2026));
                                  var formatedDate =
                                      DateFormat.yMd().format(date!);
                                  dateC.text = formatedDate.toString();
                                },
                                decoration: const InputDecoration(
                                    hintText: 'date',
                                    border: OutlineInputBorder()),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextField(
                                controller: commentC,
                                decoration: const InputDecoration(
                                    hintText: 'comment',
                                    border: OutlineInputBorder()),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                  onPressed: () async {
                                    TaskModel task = TaskModel(
                                        taskTitle: titleC.text,
                                        date: dateC.text,
                                        message: commentC.text);
                                    await TasksDataSource.updateTask(
                                        task, currentItem);
                                    getTask();

                                    Navigator.pop(context);
                                    titleC.clear();
                                    dateC.clear();
                                    commentC.clear();
                                  },
                                  child: const Text('Save'))
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          );
        },
        itemCount: tasks.length,
      ),
    );
  }

  void getTask() async {
    tasks.clear();
    var res = await TasksDataSource.getAllTask();
    setState(() {
      tasks.addAll(res);
    });
  }
}
