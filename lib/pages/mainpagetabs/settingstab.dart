import 'package:flutter/material.dart';
import 'package:nirs/main.dart';
import 'package:nirs/themes/themes.dart';

class SettingsTabWidget extends StatelessWidget {
  const SettingsTabWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      constraints: const BoxConstraints.tightFor(width: 410),
      child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Настройки',
                      style: TextStyle(
                          fontSize: 36,
                          fontFamily: 'MontserratAlternates'
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                  thickness: 5,
                  indent: 30,
                  endIndent: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Меняем цвета',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'MontserratAlternates'
                        ),
                      ),
                    ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).focusColor),
                      ),
                      child: Icon(
                        Icons.sunny,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    )]
                  ),
                ),
              ]
          )]
      ),
    );
  }
}
