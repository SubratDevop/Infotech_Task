import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String todoTable = 'todo_table';
  String todoTableName = 'todos.db';

  String id = 'id';
  String title = 'title';
  String desc = 'description';
  String status = 'status';
  String date = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + todoTableName;
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    String query =
        'CREATE TABLE $todoTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $desc TEXT, $date TEXT, $status INTEGER)';
    await db.execute(query);
  }
}
