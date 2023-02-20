import 'package:flutter/material.dart';

class MainTabWidget extends StatelessWidget {
  const MainTabWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      constraints: const BoxConstraints.tightFor(width: 410),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Сегодня, для Вас...',
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
          const SizedBox(height: 50,),
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/philo.png'),
                  fit: BoxFit.contain
              ),
            ),
            child: SizedBox(
              width: 200,
              height: 200,
            ),
          ),
          const SizedBox(height: 30,),
          const Center(
            child: Text(
              'Жан Жак де Жар',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'MontserratAlternates',
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.yellowAccent,
                  color: Colors.black
              ),
            ),
          ),
          const SizedBox(height: 30,),
          const SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Жил поэт Жан Жар де Жуй, и он имел огромный дар. А еще был поэт Жан Жак де Жар. Вот он уже имел серьезные проблемы с ментальным здоровьем. Был госпитализирован в 1993 году в лечебницу Аркхэм.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MontserratAlternates',
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: MaterialButton(
              color: Colors.orangeAccent,
              minWidth: 100,
              onPressed: (){},
              child: const Text(
                'Добавить в избранное',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'MontserratAlternates',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}