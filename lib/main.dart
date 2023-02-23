import 'package:flutter/material.dart';
import 'package:nirs/navigation/navigation.dart';
import 'package:nirs/themes/themes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


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
  final _storage = const FlutterSecureStorage();

  void changeThemeData() {
    if (theme == createDarkTheme()) {
      theme = createLightTheme();
      _storage.write(key: 'theme', value: 'light');
      setState(() {
      });
    }
    else {
      theme = createDarkTheme();
      _storage.write(key: 'theme', value: 'dark');
      setState(() {
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkForSavedTheme();
  }

  checkForSavedTheme() async{
    String? loadedTheme = await _storage.read(key: 'theme');
    if (loadedTheme != null) {
      if (loadedTheme == 'dark') {
        theme = createDarkTheme();
      } else {
        theme = createLightTheme();
      }
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


