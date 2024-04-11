import 'package:todo_list/view/home_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ToDoListApp());
}

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TodoHome(),
      theme: ThemeData().copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
              primary: Colors.blue,
              secondary: Colors.amber,
              tertiary: Colors.red)),
      debugShowCheckedModeBanner: false,
    );
  }
}
