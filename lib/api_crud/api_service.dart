import 'dart:convert';

import 'package:app_voluntariado/search_view.dart';
import 'package:http/http.dart' as http;

class ApiServiceAdmin {
  String BASEURL = 'http://apivoluntariado.centralus.azurecontainer.io:5007/';

  Future<List<Activity>> fetchActivities() async {
    try {
      final response = await http.get(Uri.parse('${BASEURL}getactivities'));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((activity) => Activity.fromJson(activity))
            .toList();
      } else {
        throw Exception('Failed to load activities from API');
      }
    } catch (e) {
      throw Exception('Failed to load activities from API');
    }
  }

//editar actividad
  Future<Activity> updateActivity(Activity activity) async {
    final response = await http.put(
      Uri.parse('${BASEURL}updateactivities/${activity.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'title': activity.title,
        'description': activity.description,
        'category': activity.category,
        'date': activity.date,
        'hour': activity.hour,
        'duration': activity.duration,
        'location': activity.location,
        'status': activity.status,
        'maxVolunteers': activity.maxParticipants,
        'volunteers': activity.participants,
      }),
    );
    if (response.statusCode == 200) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update activity');
    }
  }

  //crear actividad
  Future<Activity> createActivity(Activity activity) async {
    final response = await http.post(
      Uri.parse('${BASEURL}createactivities'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'title': activity.title,
        'description': activity.description,
        'category': activity.category,
        'date': activity.date,
        'hour': activity.hour,
        'duration': activity.duration,
        'location': activity.location,
        'status': activity.status,
        'maxVolunteers': activity.maxParticipants,
        'volunteers': activity.participants,
      }),
    );
    if (response.statusCode == 200) {
      return Activity.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create activity');
    }
  }

  //eliminar actividad
  Future<void> deleteActivity(String id) async {
    final response =
        await http.delete(Uri.parse('${BASEURL}deleteactivities/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }

  //buscar actividades por categoria
  Future<List<Activity>> fetchActivitiesByCategory(String category) async {
    final response =
        await http.get(Uri.parse('${BASEURL}search_category/$category'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((activity) => Activity.fromJson(activity))
          .toList();
    } else {
      throw Exception('Failed to load activities from API');
    }
  }

  //buscar actividades por fecha
  Future<List<Activity>> fetchActivitiesByDate(String date) async {
    final response = await http.get(Uri.parse('${BASEURL}search_date/$date'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((activity) => Activity.fromJson(activity))
          .toList();
    } else {
      throw Exception('Failed to load activities from API');
    }
  }

  //buscar actividades por location
  Future<List<Activity>> fetchActivitiesByLocation(String location) async {
    final response =
        await http.get(Uri.parse('${BASEURL}search_location/$location'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((activity) => Activity.fromJson(activity))
          .toList();
    } else {
      throw Exception('Failed to load activities from API');
    }
  }

//obtner todos los participantes (getUsers) con la lista de usuarios

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('${BASEURL}getusers'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users from API');
    }
  }

// obtener actividades por nombre
  Future<List<Activity>> getActivitiesByName(String name) async {
    final response = await http.get(Uri.parse('${BASEURL}getActivitiesByName/$name'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((activity) => Activity.fromJson(activity))
          .toList();
    } else {
      throw Exception('Failed to load activities from API');
    }
  }

  //create comments
  Future<void> createcomments(comment) async {
    final response = await http.post(
      Uri.parse('${BASEURL}createcomments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'comment': comment,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create comment');
    }
  }

  //get comments by activityId
  Future<List<Comment>> getCommentsByActivityId(String activityId) async {
    final response = await http.get(Uri.parse('${BASEURL}getcomments/$activityId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((comment) => Comment.fromJson(comment))
          .toList();
    } else {
      throw Exception('Failed to load comments from API');
    }
  }


}

class Comment {
  final String comment;
  final String date;
  final String fullName;
  final double rating;

  Comment({
    required this.comment,
    required this.date,
    required this.fullName,
    required this.rating,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      comment: json['comment'] ?? '',
      date: json['date'] ?? '',
      fullName: json['fullName'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'date': date,
      'fullName': fullName,
      'rating': rating,
    };
  }
}

class Activity {
  final String id;
  final String title;
  final String description;
  final String date;
  final String hour;
  final String location;
  final String category;
  final int maxParticipants;
  final List<String> participants;
  final String status;
  final int duration;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.hour,
    required this.location,
    required this.category,
    required this.maxParticipants,
    required this.participants,
    required this.status,
    required this.duration,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      hour: json['Hour'] ?? '',
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      maxParticipants: int.tryParse(json['maxVolunteers'].toString()) ?? 0,
      participants: List<String>.from(json['volunteers'] ?? []),
      status: json['status'] ?? '',
      duration: int.tryParse(json['duration'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'date': date,
      'hour': hour,
      'location': location,
      'category': category,
      'maxVolunteers': maxParticipants,
      'volunteers': participants,
      'status': status,
      'duration': duration,
    };
  }
}

class User {
  final String id;
  final String email;
  final String name;
  final String lastName;
  final String fullName;
  final String password;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
    required this.fullName,
    required this.password,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
      fullName: '${json['name']} ${json['last_name']}',
      password: json['password'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'name': name,
      'last_name': lastName,
      'password': password,
      'phone': phone,
      'role': role,
    };
  }
}
