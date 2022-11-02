import 'package:flutter/material.dart';

class RegistrationPageWidget extends StatelessWidget {
  const RegistrationPageWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShaderMask(
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
              // Нужно найти подходящую картинку, чтобы она была широкой
              // на больших экранах и небольшой на телефонах
            ),
          ),
        ],
      ),
    );
  }
}
