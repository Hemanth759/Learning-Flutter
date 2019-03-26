import 'package:flutter/material.dart';

class NoteList extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends State<NoteList> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Notes'),
      ),

      body: GetListView(),

      floatingActionButton: FloatingActionButton(
        
        child: Icon(Icons.add),

        onPressed: () {
          debugPrint('Bugged the dee');
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
              backgroundColor: Colors.yellow,
              child: Icon(Icons.keyboard_arrow_right),
            ),

            title: Text('Dummy Title', style: titlestyle),

            subtitle: Text('Dummy Date'),

            trailing: Icon(Icons.delete, color: Colors.grey),

            onTap: () {
              debugPrint("debugged");
            },
          ),
        );
      },
    );
  } 
}