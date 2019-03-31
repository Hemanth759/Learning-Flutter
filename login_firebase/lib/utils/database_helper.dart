import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:login_firebase/models/user.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userTable = 'Users';
  String colId = 'id';
  String colUserName = 'username';
  String colUserType = 'usertype';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if(_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'users.db';

    var usersdatabase = openDatabase(path,version: 1,onCreate: _createDB);
    return usersdatabase;
  }

  Future<void> _createDB(Database db,int version) async {
    await db.execute('CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colUserName TEXT, $colUserType TEXT) ');
  }

  // crud operations
  // fetch all users
  Future<List<Map<String,dynamic>>> getUserMapList() async {
    Database db = await this.database;

    var result = db.rawQuery('SELECT * FROM $userTable ORDER BY $colId ASC');
    return result;
  }

  // insert into table
  Future<int> insertUser(User user) async {
    Database db = await this.database;

    int result = await db.insert(userTable, user.toMap());
    return result;
  }

  // update the table
  Future<int> updateUser(User user) async {
    Database db = await this.database;

    int result = await db.update(userTable, user.toMap(), where: '$colId : ?', whereArgs: [user.id]);
    return result;
  }

  // delete from table
  Future<int> deleteUser(String username) async {
    Database db = await this.database;

    int result = await db.rawDelete('DELETE FROM $userTable WHERE $colUserName = \'$username\'');
    return result;
  }

  // get number of users
  Future<int> getTotalUserCount() async {
    Database db = await this.database;

    List<Map<String, dynamic>> countmap = await db.rawQuery('SELECT COUNT (*) FROM $userTable');
    int result = Sqflite.firstIntValue(countmap);
    return result;
  }

  Future<List<User>> getUserList() async {
    var usermaplist = await getUserMapList();
    int count = usermaplist.length;

    List<User> userslist = List<User>();
    for(int i = 0;i<count ;++i) {
      userslist.add(User.fromMapObject(usermaplist[i]));
    }
    return userslist;
  }
}