import 'package:flutter/material.dart';
import 'package:nirs/navigation/navigation.dart';
import 'package:nirs/themes/themes.dart';



void main() {
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();

}

class MyAppState extends State<MyApp> {

  ThemeData theme = createDarkTheme();

  void changeThemeData() {
    if (theme == createDarkTheme()) {
      theme = createLightTheme();
      setState(() {
      });
    }
    else {
      theme = createDarkTheme();
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var initRoute = Navigation.registrationPage;

    return MaterialApp(
      title: 'Daily Philosophy',
      debugShowCheckedModeBanner: false,
      theme: theme,
      initialRoute: initRoute,
      routes: Navigation.routes,
    );
  }
}


