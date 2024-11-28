import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  final String baseUrl = 'http://apivoluntariado.centralus.azurecontainer.io:5007'; //endpoint

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getusers'));

      if (response.statusCode == 200) {
        final List<dynamic> userJson = json.decode(response.body);
        return userJson.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar usuarios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión o formato incorrecto: $e');
    }
  }

  Future<void> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createusers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al crear usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al intentar crear usuario: $e');
    }
  }

  Future<void> updateUser(String id, User user) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/updateusers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al intentar actualizar usuario: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/deleteusers/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar usuario: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al intentar eliminar usuario: $e');
    }
  }
}
