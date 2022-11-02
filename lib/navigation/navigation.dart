import 'package:flutter/material.dart';
import 'package:nirs/pages/registrationPage.dart';

abstract class Navigation {
  static const registrationPage = "/";

  static Map<String, Widget Function(BuildContext)> get routes => {
    registrationPage : (BuildContext context) => RegistrationPageWidget(),
  };
}