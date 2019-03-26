import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NoteDetailState();
  }
}

class _NoteDetailState extends State<NoteDetail> {
  static List<String> _priotites = ['High', 'Low'];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textstyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
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
                value: 'Low',
                onChanged: (valueSelectByUser) {
                  setState(() {
                    debugPrint('User Selected $valueSelectByUser');
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
}
