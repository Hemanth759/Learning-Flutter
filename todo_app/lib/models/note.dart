class Note {
  int _id;
  int _priority;
  String _title;
  String _description;
  String _date;

  // Creating the constructor
  Note(this._title, this._date, this._priority, [this._description]);
  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  // Setting get fucntions for the variables
  int get id => _id;
  int get priority => _priority;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  //Setting set functions for the variables
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  set date(String newdate) {
    this._date = newdate;
  }

  set description(String newdescription) {
    this._description = newdescription;
  }

  //Creating function to convert note object to map object
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['priority'] = _priority;
    map['description'] = _description;
    map['date'] = _date;

    return map;
  }

  //Extract the map to object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._priority = map['priority'];
    this._description = map['description'];
    this._date = map['date'];
  }
}
