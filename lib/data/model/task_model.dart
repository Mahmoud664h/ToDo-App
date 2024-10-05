class TaskModel {
  int? id;
  String? taskTitle;
  String? date;
  String? message;
  bool? isDone;

  TaskModel(
      {required this.taskTitle,
      required this.date,
      required this.message,
      this.isDone = false});
  TaskModel.fromJson(Map json) {
    id = json['id'];
    taskTitle = json['taskTitle'];
    date = json['data'];
    message = json['message'];
    isDone = json['isDone'] == 0 ? false : true;
  }
}
