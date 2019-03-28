import 'package:flutter/material.dart';
import 'package:todo_app/models/note.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note,this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState();
  }
}

class _NoteDetailState extends State<NoteDetail> {
  static List<String> _priotites = ['High', 'Low'];

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.title;

    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            // First Element
            ListTile(
              title: DropdownButton(
                items: _priotites.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                style: textstyle,
                value: getPriorityString(widget.note.priority),
                onChanged: (valueSelectByUser) {
                  setState(() {
                    debugPrint('User Selected $valueSelectByUser');
                    updatePriorityAsInt(valueSelectByUser);
                  });
                },
              ),
            ),

            //Second Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textstyle,
                onChanged: (value) {
                  debugPrint(
                      'Something changed in the title text field as $value');
                      updateTitle();
                },
                decoration: InputDecoration(
                    labelStyle: textstyle,
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Third element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textstyle,
                onChanged: (value) {
                  debugPrint(
                      'Something changed in the description text field as $value');
                      updateDescription();
                },
                decoration: InputDecoration(
                    labelStyle: textstyle,
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Fourth element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('Pressed the save button');
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Delete',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint('Pressed the delete button');
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Convert string to integer of priority before saving it to database
  void updatePriorityAsInt(String value) {
    if(value == 'High') {
      widget.note.priority = 1;
    }
    else {
      widget.note.priority = 2;
    }
  }

  String getPriorityString(int value) {
    if (value == 1)
      return _priotites[0];
    else
      return _priotites[1];
  }

  void updateTitle() {
    widget.note.title = titleController.text;
  }

  void updateDescription() {
    widget.note.description = descriptionController.text;
  }

  void _save() async {
    
    Navigator.pop(context,true);
    
    widget.note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(widget.appBarTitle == 'Add Note') {
      result = await helper.insertNote(widget.note);
    }
    else {
      result = await helper.updateNote(widget.note);
    }

    if(result == 0){
      _showAlertDialog('Status', 'Problem saving the note');
    }
    else {
      _showAlertDialog('Status', 'successfully saved the note');
    }
  }

  void _delete() async {

    Navigator.pop(context,true);

    if(widget.appBarTitle == 'Add Note') {
      _showAlertDialog('Status', 'No note was deleted');
      return;
    }
    int result = await helper.deleteNote(widget.note.id);
    if(result != 0)
      _showAlertDialog('Status', 'Note Deleted Successfully');
    else
      _showAlertDialog('Status', 'Problem in deleting the note');
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );    
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
