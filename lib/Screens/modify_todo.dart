import 'package:flutter/material.dart';

import '../model/Model_todo.dart';
import '../ServicerWrapper/Service_todo.dart';

class modify_todo extends StatefulWidget {
  final String appBarTitle;
  final Model_todo todo;

  modify_todo(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return modify_todoState(this.todo, this.appBarTitle);
  }
}

class modify_todoState extends State<modify_todo> {
  Service_todo service = Service_todo();

  String appBarTitle;
  Model_todo todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  modify_todoState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitle,
              style: TextStyle(color: Colors.white, fontFamily: 'Karla'),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
              color: Colors.white,
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      todo.title = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: "Enter title here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value) {
                      todo.description = value;
                    },
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: 'Description',
                      hintText: "Enter description here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    maxLines: 5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text('Save', textScaleFactor: 1.5),
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      todo.id != null
                          ? Expanded(
                              child: RaisedButton(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                color: Colors.redAccent,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text('Delete', textScaleFactor: 1.5),
                                onPressed: () {
                                  setState(() {
                                    _delete();
                                  });
                                },
                              ),
                            )
                          : Container(width: 0.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void _save() async {
    moveToLastScreen();

    /**
     * create new todoItem if todoId is null
     */
    int result = todo.id != null
        ? await service.updateTodo(todo)
        : await service.insertTodo(todo);

    String resultMsg = 'Todo saved successfully...';
    if (result == 0) resultMsg = 'Oops, problem with saving todo...';

    _showAlertDialog('Status', resultMsg);
  }

  void _delete() async {
    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    /**
     * Case 2: User is trying to delete the old todo that already has a valid ID.
     */
    int result = await service.deleteTodo(todo.id);

    String resultMsg = 'Todo deleted successfully...';
    if (result == 0) resultMsg = 'Oops, error occured while deleting todo';

    _showAlertDialog('Status', resultMsg);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
