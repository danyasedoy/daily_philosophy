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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w300,
          )
        )
      ),
      initialRoute: Navigation.registrationPage,
      routes: Navigation.routes,
    );
  }
}


