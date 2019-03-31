import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:login_firebase/screens/register.dart';
import 'package:login_firebase/screens/view_users.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> formkey =GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email',),
                  validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) {
                    _email = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                  onSaved: (value) {
                    _password = value;
                  },
                ),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: validateAndSubmit,
                ),
                FlatButton(
                  child: Text('Register', style: TextStyle(fontSize: 15.0),),
                  onPressed: moveToRegisterScreen,
                ),
                FlatButton(
                  child: Text('View All Users'),
                  onPressed: moveToUsersViewScreen,
                )
              ],
            ),
          )
        )
      );
  }

  bool validateLoginForm() {
    final FormState form = formkey.currentState;
    if (form.validate()) {
      form.save();
      // debugPrint('Email : $_email\nPassword: $_password');
      return true;
    }
    else
      return false;
  }

  void validateAndSubmit() async {
    if(validateLoginForm()) {
      // debugPrint('Validated the form');
      try {
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      debugPrint('Successfully logged into user: ${user.uid}');
      }
      catch (error) {
        print('error: $error');
      }
    }
    else {
      debugPrint('Form not validated');
    }
  }

  void moveToRegisterScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegisterPage();
    }));
  }

  void moveToUsersViewScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewUsers();
    }));
  }
}
