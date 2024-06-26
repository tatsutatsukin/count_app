import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'objectbox.g.dart';
//import 'memberData.dart';
import 'screens/input.dart';
import 'screens/graph.dart';

late Store? store;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Count Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //画面下のメニュバー(bottomNavigationBar)によって切り替えられるメイン画面の一覧
  static const screens = [InputScreen(), GraphScreen()];

  int selectedIndex = 0; //デフォルトでは入力画面を表示する

  //画面下のメニュバー(bottomNavigationBar)のアイコンが押された時の挙動
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '入力'),
          BottomNavigationBarItem(
              icon: Icon(Icons.incomplete_circle), label: 'グラフ'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
