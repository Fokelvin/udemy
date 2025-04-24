import 'package:flutter/material.dart';
import 'package:tarefas/pages/todo_list_page.dart';

void main() {
  runApp( MayApp());
}

class MayApp extends StatelessWidget {
  MayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage()
      );
  }
}