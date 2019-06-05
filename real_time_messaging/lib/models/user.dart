import 'package:firebase_auth/firebase_auth.dart';

class User {
  // user attributes
  String _userId;
  String _imgLoc;
  String _name;

  // getters for variables
  String get userId => this._userId;
  String get imgLoc => this._imgLoc;
  String get name => this._name;

  // setters for varaibles
  set imgLoc (String value) => this._imgLoc = value;
  set name (String value) => this._name = value;

  // basic constructor
  User({String name, String imgLoc, String userId}) {
    this.name = name;
    this.imgLoc = imgLoc;
  }

  /// returns user object from the given firebase user as parameters
  User.fromFirebaseAuth(FirebaseUser user) {
    this.name = user.displayName;
    this.imgLoc = user.photoUrl;
    this._userId = user.uid;
  }

  /// returns map of user object
  Map<String, dynamic> toMap() {
    Map<String,dynamic> map = Map<String,dynamic>();
    map['userId'] = this.userId;
    map['imgLoc'] = this.imgLoc;
    map['name'] = this.name;

    return map;
  }

  User.fromFireStoreCloud(Map<String, dynamic> map) {
    this._userId = map['userId'];
    this.name = map['name'];
    this.imgLoc = map['imgLoc'];
  }
}
