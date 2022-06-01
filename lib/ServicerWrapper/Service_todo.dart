import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

import '../helper/database.dart';
import '../model/Model_todo.dart';

class Service_todo {
  DatabaseHelper databaseHelper = DatabaseHelper();

  String todoTable = 'todo_table';

  String id = 'id';
  String title = 'title';
  String desc = 'description';
  String status = 'status';
  String date = 'date';

  Service_todo() {
    debugPrint('Service_todo construct...');
  }

  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.databaseHelper.database;

    return await db.query(todoTable, orderBy: '$title ASC');
  }

  Future<int> insertTodo(Model_todo todo) async {
    Database db = await databaseHelper.database;
    var result = await db.insert(todoTable, todo.toMap());
    return result;
  }

  Future<int> updateTodo(Model_todo todo) async {
    var db = await this.databaseHelper.database;
    var result = await db.update(
      todoTable,
      todo.toMap(),
      where: '$id = ?',
      whereArgs: [todo.id],
    );
    return result;
  }

  Future<int> deleteTodo(int _id) async {
    var db = await this.databaseHelper.database;

    String query = 'DELETE FROM $todoTable WHERE $id = $_id';
    int result = await db.rawDelete(query);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.databaseHelper.database;

    String query = 'SELECT COUNT (*) from $todoTable';

    List<Map<String, dynamic>> x = await db.rawQuery(query);
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Model_todo>> getTodoList() async {
    var todoMapList = await getTodoMapList();

    int count = todoMapList.length;

    List<Model_todo> todoList = List<Model_todo>();

    for (int i = 0; i < count; i++) {
      todoList.add(Model_todo.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }
}
