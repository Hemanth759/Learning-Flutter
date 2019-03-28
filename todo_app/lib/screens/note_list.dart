import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/note_detail.dart';
import 'package:todo_app/models/note.dart';
import 'package:todo_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: GetListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          debugPrint('Pressed the add note button');
          navigateToDetail(Note('','',2),'Add Note');
        },
        tooltip: 'Add Note',
      ),
    );
  }

  ListView GetListView() {
    TextStyle titlestyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            title: Text(this.noteList[position].title, style: titlestyle),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
                child: Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  _delete(context, this.noteList[position]);
                }),
            onTap: () {
              debugPrint("Pressed on the listtile");
              navigateToDetail(this.noteList[position],'Edit Note');
            },
          ),
        );
      },
    );
  }

  // returns priority color
  Color getPriorityColor(int priority) {
    if (priority == 1) {
      return Colors.red;
    }
    return Colors.yellow;
  }

  // returns icon based on priority
  Icon getPriorityIcon(int priority) {
    if (priority == 1) {
      return Icon(Icons.play_arrow);
    }
    return Icon(Icons.keyboard_arrow_right);
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note,String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if(result == true)
      updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.database;
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
         this.noteList = noteList;
         this.count =noteList.length; 
        });
      });
    });
  }
}
