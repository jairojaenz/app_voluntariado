import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(String name, String password) async {
  try {
    final url = Uri.parse('http://apivoluntariado.centralus.azurecontainer.io:5007/login');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'password': password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'message': 'Error en el inicio de sesion'};
    }
  } catch (e) {
    return {'message': 'Error de conexión: $e'};
  }
}

