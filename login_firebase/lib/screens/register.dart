import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  
  final GlobalKey<FormState> formkey =GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
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
                validator: (value) => (value.isEmpty || value.length < 6) ? 'Password can\'t be empty and at least 6 letters' : null,
                onSaved: (value) {
                  _password = value;
                },
              ),
              RaisedButton(
                child: Text('Create account'),
                onPressed: validateAndSubmit,
              ),
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
    return true;
  }
  else
    return false;
  }

  void validateAndSubmit() async {
    if(validateLoginForm()) {
      debugPrint('Validated the form');
      try {
        FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
        );
        print('User :: ${user.uid}');
      }
      catch (error) {
        print('error: '+error);
      }
    }
  }
}