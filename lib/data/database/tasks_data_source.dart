import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/model/task_model.dart';

class TasksDataSource {
  static late Database database;

  static Future<void> initialize() async {
    database = await openDatabase('todo.db', onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, taskTitle TEXT,data TEXT,message TEXT, isDone INTEGER)');
      print('on create DB is called');
    }, onOpen: (db) {
      print('on open DB is called');
    }, version: 1);
  }

  static insertTask(TaskModel task) async {
    await database.rawInsert(
        'INSERT INTO Tasks(taskTitle, data, message,isDone) VALUES("${task.taskTitle}", "${task.date}","${task.message}",${task.isDone! ? 1 : 0})');
  }

  static Future<List<TaskModel>> getAllTask() async {
    List<Map> listOfMap = await database.rawQuery('SELECT * FROM Tasks');
    List<TaskModel> tasks = [];
    for (var element in listOfMap) {
      var model = TaskModel.fromJson(element);
      tasks.add(model);
    }
    return tasks;
  }

  static toggleTask(TaskModel task) async {
    int isDone = task.isDone! ? 0 : 1;

    await database
        .rawUpdate('UPDATE Tasks SET isDone = $isDone WHERE id = ${task.id}');
  }

  static deleteTask(TaskModel task) async {
    await database.rawDelete('DELETE FROM Tasks WHERE id = ${task.id}');
  }

  static updateTask(TaskModel task, TaskModel oldTask) async {
    await database.rawUpdate(
      'UPDATE Tasks SET taskTitle = "${task.taskTitle}", data = "${task.date}", message = "${task.message}" WHERE id = ${oldTask.id}',
    );
  }
}
