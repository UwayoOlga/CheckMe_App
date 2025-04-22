import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(CheckMeApp());
}

class CheckMeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CheckMe – Todo App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.pink,
          secondary: Colors.pink[200]!,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.pink[700]!,
          secondary: Colors.pink[400]!,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}