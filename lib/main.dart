import 'package:flutter/material.dart';
import 'package:nirs/navigation/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Philosophy',
      theme: ThemeData(),
      initialRoute: Navigation.registrationPage,
      routes: Navigation.routes,
    );
  }
}


