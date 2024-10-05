import 'package:flutter/material.dart';
import 'package:todo_app/UI/screen/todo_screen.dart';
import 'package:todo_app/data/database/tasks_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TasksDataSource.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoScreen(),
    );
  }
}
