import 'package:flutter/material.dart';

import 'package:simple_todo_list/Screens/modify_todo.dart';

import '../model/Model_todo.dart';
import '../ServicerWrapper/Service_todo.dart';

class List_todo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return List_todoState();
  }
}

class List_todoState extends State<List_todo> {
  bool _isSnackbarActive = false;

  Service_todo service = Service_todo();

  List<Model_todo> todoList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Model_todo>();
      fetchToView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo',
          style: TextStyle(color: Colors.white, fontFamily: 'Karla'),
        ),
        centerTitle: true,
      ),
      body: todoList.isEmpty ? emptyTodo() : getTodoListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTomodify_todo(Model_todo('', 0, ''), 'New Todo ');
        },
        tooltip: 'Todo',
        child: Icon(Icons.add, size: 30, color: Colors.white),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Container emptyTodo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text("No Todos listed...", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.purple)),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              child: Checkbox(
                value: this.todoList[position].statusBool,
                onChanged: (value) {
                  setState(() {
                    this.todoList[position].statusBool = value;
                    _updateStatus(context, todoList[position]);
                  });
                },
              ),
            ),
            title: Text(
              this.todoList[position].title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Karla',
                decoration: this.todoList[position].status != 0
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                this.todoList[position].description,
                maxLines: 3,
                style: TextStyle(
                  decoration: this.todoList[position].status != 0
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.close, color: Colors.red, size: 30),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateTomodify_todo(this.todoList[position], ' Todo Updated');
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Model_todo todo) async {
    int result = await service.deleteTodo(todo.id);
    if (result != 0) {
      if (!_isSnackbarActive) _showToast(context, 'Todo deleted');

      fetchToView();
    }
  }

  void _updateStatus(BuildContext context, Model_todo todo) async {
    int result = await service.updateTodo(todo);
    if (result != 0) {
      String resultMsg = 'Mark  pending...';
      if (todo.status == 1) {
        resultMsg = 'Mark done...';
      }
      if (!_isSnackbarActive) _showToast(context, resultMsg);
    }
  }

  void _showToast(BuildContext context, String message) {
    _isSnackbarActive = true;

    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
      ),
    );
    Scaffold.of(context)
        .showSnackBar(snackBar)
        .closed
        .then((SnackBarClosedReason reason) {
      _isSnackbarActive = false;
    });
  }

  void navigateTomodify_todo(Model_todo todo, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return modify_todo(todo, title);
      },
    ));

    if (result == true) {
      fetchToView();
    }
  }

  void fetchToView() {
    Future<List<Model_todo>> todoListFuture = service.getTodoList();
    todoListFuture.then((todoList) {
      setState(() {
        this.todoList = todoList;
        this.count = todoList.length;
      });
    });
  }
}
