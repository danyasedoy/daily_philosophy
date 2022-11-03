import 'package:flutter/material.dart';

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
               const Padding(
                 padding:  EdgeInsets.symmetric(vertical: 10),
                 child:  WelcomeTextWidget(),
               ),
               Container(
                 height: MediaQuery.of(context).size.height / 5 * 3.5,
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

class PasswordTextFieldWidget extends StatelessWidget {
  const PasswordTextFieldWidget({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: passwordController,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Пароль',
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
          decoration: const InputDecoration(
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

class WelcomeTextWidget extends StatelessWidget {
  const WelcomeTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Добро пожаловать",
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

class RegistrationBackgroundWidget extends StatelessWidget {
  const RegistrationBackgroundWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height / 5 * 4,
            maxWidth: 350,
          ),
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
              ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
            },
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/registration_bg_image.jpg',

            ),
          ),
        ),
      ),
    );
  }
}
