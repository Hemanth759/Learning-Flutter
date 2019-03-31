class User {
  int _id;
  String _username;
  String _usertype;

  // creating the constructor
  User(this._username,this._usertype);
  User.withId(this._id,this._username,this._usertype);

  // get fuctions for variables
  int get id {
    return _id;
  }

  String get username {
    return _username;
  }

  String get usertype {
    return _usertype;
  }

  // setter functions for the variables
  set id(int value) {
    this._id = value;
  }

  set username(String value) {
    this._username = value;
  }

  set usertype(String value) {
    this._usertype = value;
  }

  // functions to convert the user to map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    if(id != null) {
      map['id'] = _id;
    }
    map['username'] = _username;
    map['usertype'] = _usertype;

    return map;
  }

  // function to convert map to user object
  User.fromMapObject(Map<String,dynamic> map) {
    this._id = map['id'];
    this._username = map['username'];
    this._usertype = map['usertype'];
  }
}