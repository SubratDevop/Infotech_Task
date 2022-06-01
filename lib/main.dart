import 'package:flutter/material.dart';
import 'package:simple_todo_list/Screens/List_todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Task App',
      theme: ThemeData(primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: List_todo(),
    );
  }
}
