import 'package:SampleApp/Screens/AddTask.dart';
import 'package:flutter/material.dart';
import '../Extensions/Color_Extension.dart';
import '../Modal/TaskModal.dart';
import 'package:sqflite/sqflite.dart';
import '../Helper/db_helper.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeAppState();
  }
}

class _HomeAppState extends State<Home> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
        if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }
    return Scaffold(
            appBar: AppBar(title: Text('ToDo App'),
            backgroundColor: 
              '2A5470'.toColor(),
            actions: <Widget>[
              Padding(padding: EdgeInsets.only (right: 20.0),
              child: GestureDetector (
                onTap: () {
                  navigateToDetail(Todo('', '', ''), 'Add Task');
                },
                child: Icon(
                  Icons.add,
                  size: 26,
                ),
                
              ),
              )
            ],
            ),
            body: initBody(),
          );
  }
  initBody() {
    return new Container(
      child: Stack(
        children: [
            Container(
          decoration: BoxDecoration(
            color: '2A5470'.toColor(),
            gradient: LinearGradient(colors: ['2A5470'.toColor(),'4C4177'.toColor()],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
            )
          ),
        ),
        getTodoListView(),
        ],
      ),
    );
  }
  void navigateToDetail(Todo todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTask(title,todo);
    }));

    if (result == true) {
      updateListView();
    }
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.todoList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.todoList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.todoList[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }


  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }

}
