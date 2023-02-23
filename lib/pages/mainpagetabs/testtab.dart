import 'package:flutter/material.dart';

class TestTabWidget extends StatefulWidget {
  const TestTabWidget({Key? key}) : super(key: key);

  @override
  State<TestTabWidget> createState() => _TestTabWidgetState();
}

class _TestTabWidgetState extends State<TestTabWidget> {

  Set<Text> testList =
     {
       const Text('Один', style: TextStyle(fontSize: 22, fontFamily: 'MontserratAlternates'),),
       const Text('Два', style: TextStyle(fontSize: 22, fontFamily: 'MontserratAlternates'),),
       const Text('Три', style: TextStyle(fontSize: 22, fontFamily: 'MontserratAlternates'),),
     };

  Text? currentAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      constraints: const BoxConstraints.tightFor(width: 410),
      child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Опрос',
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
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: Text(
                      'Текст опроса',
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'MontserratAlternates'
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      RadioListTile<Text>(
                        activeColor: Colors.yellow,
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: testList.elementAt(0),
                        groupValue: currentAnswer,
                        value: testList.elementAt(0),
                        onChanged:(Text? value)  {  setState(() {currentAnswer = value;});},
                      ),
                      RadioListTile<Text>(
                        activeColor: Colors.yellow,
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: testList.elementAt(1),
                        groupValue: currentAnswer,
                        value: testList.elementAt(1),
                        onChanged:(Text? value)  { setState(() {currentAnswer = value;});},
                      ),
                      RadioListTile<Text>(
                        activeColor: Colors.yellow,
                        tileColor: Theme.of(context).scaffoldBackgroundColor,
                        title: testList.elementAt(2),
                        groupValue: currentAnswer,
                        value: testList.elementAt(2),
                        onChanged:(Text? value)  { setState(() {currentAnswer = value;});},
                      ),
                    ],
                  ),
                )
              ]
          )]
      ),
    );
  }
}
