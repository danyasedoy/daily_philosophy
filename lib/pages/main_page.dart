import 'package:flutter/material.dart';

class MainPageWidget extends StatefulWidget {
  const MainPageWidget({Key? key}) : super(key: key);

  @override
  State<MainPageWidget> createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {

  int _selectedTab = 1;

  final List _tabs = const [
    Center(child: Text('Избранное')),
    MainTabWidget(),
    Center(child: Text('Настройки')),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          // image: DecorationImage(
          //     alignment: Alignment.topRight,
          //     image: null,
          //     fit: BoxFit.scaleDown
          // ),
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}

class MainTabWidget extends StatelessWidget {
  const MainTabWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 60,
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Кое-что интересное для вас...',
              style: TextStyle(
                fontSize: 36,
                fontFamily: 'MontserratAlternates'
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.yellow,
          thickness: 5,
          indent: 30,
          endIndent: 30,
        ),

      ],
    );
  }
}
