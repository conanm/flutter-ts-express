import 'package:flutter/material.dart';
import 'package:frontend/activitypage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Koa Health'),
      ),
      body: Center(child: LoginForm()),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = 'john@example.com';
  String _password = 'securepassword';
  String _errorMessage = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ApiService().login(_email, _password).then((success) {
        if (success) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ActivityPage()),
          );
        } else {
          setState(() {
            _errorMessage = 'Invalid email or password';
          });
        }
      }).catchError((error) {
        setState(() {
          _errorMessage = 'Failed to login: $error';
        });
      });
    } else {
      setState(() {
        _errorMessage = 'Please correct the errors in the form';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your email';
              }
              return null;
            },
            initialValue: 'john@example.com',
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            initialValue: 'securepassword',
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (value) => _password = value?.trim() ?? '',
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Login'),
          ),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
