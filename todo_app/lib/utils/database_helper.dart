import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_Table';
  String colId = 'id';
  String colTitle = 'title';
  String colPriority = 'priority';
  String colDescription = 'description';
  String colDate = 'date';
  
  DatabaseHelper._createInstance();
  


  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'note.db';

    // open or create the database at the given path
    var notesDatabase = openDatabase(path, version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
          '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  // CRUD OPERATIONS
  // Fetch operation to get all objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $noteTable ORDER BY $colPriority ASC');
    return result;
  }

  // Insert operation
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = db.insert(noteTable, note.toMap());
    return result;
  }

  // Update operation
  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    // var result = await db.rawQuery('INSERT INTO $noteTable($colId, $colTitle, $colPriority, $colDate, $colDescription) VALUES'
    //                   ' (${note.id},${note.title},${note.priority},${note.date},${note.description})');
    return result;
  }

  // Delete operation
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get number of objects in table
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> countMap = await db.rawQuery('SELECT COUNT (*) FROM $noteTable');
    int result = Sqflite.firstIntValue(countMap);
    return result;
  }

  // Get the map list and convert it to note list
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count =noteMapList.length;

    List<Note> noteList =List<Note>();
    for(int i = 0;i<count;i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

}
