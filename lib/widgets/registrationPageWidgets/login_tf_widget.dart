import 'package:flutter/material.dart';

class LoginTextFieldWidget extends StatelessWidget {
  const LoginTextFieldWidget({
    Key? key,
    required this.loginController,
  }) : super(key: key);

  final TextEditingController loginController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: loginController,
          maxLength: 20,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            counterText: "",
            labelText: 'Логин',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
            fillColor: Colors.black45,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.yellow,
                width: 4,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.yellow,
                width: 4,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ),
    );
  }
}