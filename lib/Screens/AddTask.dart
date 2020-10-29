import 'package:SampleApp/Modal/TaskModal.dart';
import 'package:flutter/material.dart';
import '../Extensions/Color_Extension.dart';
import '../Helper/db_helper.dart';
import 'package:intl/intl.dart';


class AddTask extends StatefulWidget {
  final String appTitle;
  final Todo todo;
  AddTask(this.appTitle, this.todo);

  @override
    State<StatefulWidget> createState() {
    return _AddTaskState(this.appTitle, this.todo);
  }
}

class _AddTaskState extends State<AddTask> {
  String appTitle;
  Todo todo;
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _validate = false;
	DatabaseHelper helper = DatabaseHelper();

  _AddTaskState(this.appTitle, this.todo);

  @override
  Widget build(BuildContext context) {
    _title.text = todo.title;
		_description.text = todo.description;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(this.appTitle),
            backgroundColor: '2A5470'.toColor(),
          ),
          body: initBody(),
        ),
        onWillPop: () => moveToLastScreen());
  }

  initBody() {
    return new Container(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: '2A5470'.toColor(),
                gradient: LinearGradient(
                    colors: ['2A5470'.toColor(), '4C4177'.toColor()],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                TextField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _title,
                  decoration: new InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      hintText: "Enter your task ...",
                      errorText:
                          _validate ? 'This field can\'t be empty' : null,
                      errorStyle: TextStyle(color: Colors.red)),
                  onChanged: (String value) async {
                    updateTitle();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  controller: _description,
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                    hintText: 'Enter description(optional)',
                  ),
                    onChanged: (String value) async {
                    updateDescription();
                  },
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {
                        _save();
                      });
                    },
                    child: (todo.id != null) ? Text('Update') : Text('Submit'),
                    textColor: Colors.white,
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  moveToLastScreen() {
    Navigator.pop(context, true);
  }

  	// Update the title of todo object
  void updateTitle(){
    todo.title = _title.text;
  }

	// Update the description of todo object
	void updateDescription() {
		todo.description = _description.text;
	}

	// Save data to database
	void _save() async {
   if (_title.text.isEmpty) {
     _validate = true;
   } else {
     _validate = false;
     	moveToLastScreen();
       	todo.date = DateFormat.yMMMd().format(DateTime.now());
		int result;
		if (todo.id != null) {  // Case 1: Update operation
			result = await helper.updateTodo(todo);
		} else { // Case 2: Insert Operation
			result = await helper.insertTodo(todo);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Todo Saved Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Todo');
		}
   }

   }  
	
  	void _showAlertDialog(String title, String message) {
		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}
}
