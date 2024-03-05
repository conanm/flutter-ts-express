import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity {
  final int id;
  final String title;
  final String description;
  final Bool completed;

  Activity(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      isActive: json['isActive'],
    );
  }
}

class ApiService {
  final String baseUrl = "http://localhost:3000";
  String _token = '';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<List<Activity>> getActivities() async {
    final response = await http.get(
      Uri.parse('$baseUrl/activities'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Activity.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load activities');
    }
  }

  Future<void> toggleActivity(int id) async {
    final response =
        await http.patch(Uri.parse('$baseUrl/activities/$id/toggle'));
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle activity');
    }
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var token = json.decode(response.body)['token'];

      _token = token;
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login');
    }
  }
}

class ActivityPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Activities'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: apiService.getActivities(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  trailing: Switch(
                    value: snapshot.data![index].isActive,
                    onChanged: (bool value) {
                      snapshot.data![index].isActive = value;
                      apiService.toggleActivity(snapshot.data![index].id);
                    },
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
