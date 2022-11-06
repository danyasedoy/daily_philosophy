import 'package:flutter/material.dart';
import 'package:nirs/widgets/registrationPageWidgets/already_have_acc_button.dart';
import 'package:nirs/widgets/registrationPageWidgets/login_tf_widget.dart';
import 'package:nirs/widgets/registrationPageWidgets/password_tf_widget.dart';
import 'package:nirs/widgets/registrationPageWidgets/registration_button.dart';
import 'package:nirs/widgets/registrationPageWidgets/welcome_text_widget.dart';

class RegistrationPageWidget extends StatelessWidget {
  RegistrationPageWidget ({Key? key}) : super(key: key);

  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body : ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              children: [
                const WelcomeTextWidget(),
                RegistrationTextFieldsWithBackground(loginController: loginController, passwordController: passwordController),
                const RegistrationButton(),
                const AlreadyHaveAccountButton(),
              ],
            ),
          ]
        ),

    );
  }
}

class RegistrationTextFieldsWithBackground extends StatelessWidget {
  const RegistrationTextFieldsWithBackground({
    Key? key,
    required this.loginController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController loginController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 400,
          ),
          height: MediaQuery.of(context).size.width,
          foregroundDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).canvasColor,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [0, 1],
            ),
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/registration_bg_image.jpg"),
            ),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              LoginTextFieldWidget(loginController: loginController),
              const SizedBox(height: 20),
              PasswordTextFieldWidget(passwordController: passwordController),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ]
    );
  }
}


