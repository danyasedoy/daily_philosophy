import 'package:flutter/material.dart';
import 'package:nirs/navigation/navigation.dart';
import 'package:nirs/themes/themes.dart';



// сделать myapp stateful виджетом, который будет реагировать на изменение
// темы и вызывать set state при изменении
ThemeData theme = createDarkTheme();

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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


