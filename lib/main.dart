import 'package:app_voluntariado/admin_view.dart';
import 'package:app_voluntariado/crud_user.dart';
import 'package:app_voluntariado/pantalla_voluntariado.dart';
import 'package:app_voluntariado/search_view.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => VistaLogin(),
        '/admin': (context) => const AdminView(
          user: {},
          isAdmin: true,
        ),
        '/profile': (context) => const ProfileScreen(
          user: {},
          activities: [],
        ),
        '/user': (context) => UsersScreen(),
        '/search': (context) =>  const SearchScreen(user: {}),
      },
      initialRoute: '/login',
    );
  }
}