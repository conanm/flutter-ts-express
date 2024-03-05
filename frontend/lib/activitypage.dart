import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activity {
  final int id;
  final String title;
  final String description;
  bool completed;

  Activity(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
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

  Future<Activity> toggleActivity(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/activities/$id/toggle'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      Activity activity = Activity.fromJson(body);
      return activity;
    } else {
      throw Exception('Failed to load activity');
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

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Activities'),
      ),
      body: FutureBuilder<List<Activity>>(
        future: ApiService().getActivities(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  trailing: Switch(
                    value: snapshot.data![index].completed,
                    onChanged: (bool value) async {
                      snapshot.data![index].completed = value;
                      Activity updatedActivity = await ApiService()
                          .toggleActivity(snapshot.data![index].id);
                      snapshot.data![index] = updatedActivity;
                      setState(() {});
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
