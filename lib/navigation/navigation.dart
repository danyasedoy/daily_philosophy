import 'package:flutter/material.dart';
import 'package:nirs/pages/main_page.dart';
import 'package:nirs/pages/registration_page.dart';

abstract class Navigation {
  static const registrationPage = "/";
  static const mainPage = "/main";

  static Map<String, Widget Function(BuildContext)> get routes => {
    registrationPage : (BuildContext context) => const RegistrationPageWidget(),
    mainPage: (BuildContext context) => const MainPageWidget(),
  };
}