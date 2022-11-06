import 'package:flutter/material.dart';
import 'package:nirs/navigation/navigation.dart';
import 'package:nirs/themes/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Philosophy',
      debugShowCheckedModeBanner: false,
      theme: createLightTheme(),
      initialRoute: Navigation.registrationPage,
      routes: Navigation.routes,
    );
  }
}


