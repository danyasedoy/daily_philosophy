import 'package:flutter/material.dart';
import 'package:nirs/widgets/registrationPageWidgets/login_tf_widget.dart';
import 'package:nirs/widgets/registrationPageWidgets/password_tf_widget.dart';
import 'package:nirs/widgets/registrationPageWidgets/welcome_text_widget.dart';

class RegistrationPageWidget extends StatelessWidget {
  RegistrationPageWidget ({Key? key}) : super(key: key);

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : Align(
        alignment: Alignment.center,
        child:
          ListView(
            children: [
               const WelcomeTextWidget(),
               Container(
                 constraints: const BoxConstraints(
                   maxWidth: 400,
                   maxHeight: 400,
                 ),
                 height: MediaQuery.of(context).size.width,
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                     image: AssetImage("assets/images/registration_bg_image.jpg"),
                   ),
                 ),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     LoginTextFieldWidget(loginController: loginController),
                     PasswordTextFieldWidget(passwordController: passwordController),
                     const SizedBox(height: 20)
                   ],
                 ),
               ),
            ],
          ),
        ),
    );
  }
}


