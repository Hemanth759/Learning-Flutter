import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:login_firebase/utils/database_helper.dart';
import 'package:login_firebase/models/user.dart';

class ViewUsers extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _ViewUsersState();
  }
}

class _ViewUsersState extends State<ViewUsers> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<User> userList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(userList == null) {
      userList = List<User>();
      updateUserListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('All Users'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: getlistView(),
      ),
    );
  }

  ListView getlistView() {
    TextStyle textStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context,int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(this.userList[position].username, style: textStyle),
            subtitle: Text(this.userList[position].usertype),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                _deleteuser(context, this.userList[position]);
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteuser(BuildContext context, User user) async {
    int result = await databaseHelper.deleteUser(user.username);

    if(result == 0) {
      _showAlertDialog('Status','Problem deleting user from database');
    }
    else {
      _showAlertDialog('Status','Successfully deleted user from database');
      updateUserListView();
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) {
        return alertDialog;
      }
    );
  }

  void updateUserListView() {
    final Future<Database> dbFuture = databaseHelper.database;
    dbFuture.then((database) {
      Future<List<User>> userlistfuture = databaseHelper.getUserList();
      userlistfuture.then((userlistfuture) {
        setState(() {
        this.userList = userlistfuture;
        this.count = userlistfuture.length; 
        });
      });
    });
  }
}