import 'package:flutter/material.dart';
import 'package:nirs/pages/mainpagetabs/testtab.dart';
import 'mainpagetabs/settingstab.dart';
import 'mainpagetabs/maintab.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({Key? key}) : super(key: key);

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {

  int _selectedTab = 1;

  final List _tabs = const [
    // как сделать вкладку с избранным
    // по верстке - колумн со списком
    // по нажатию на пост -
    // агрумент с айди поста
    // передается виджету главной вкладки
    // и на ней отображается пост
    // если никакого айди не передается виджету главной вкладки
    // то открывается пост дня
    Center(child: Text('Избранное')),
    MainTabWidget(),
    TestTabWidget(),
    SettingsTabWidget(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabs[_selectedTab],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.poll), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}


