import 'package:api_deneme/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MainPage());

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Api_Test_1',
      home: HomePage(),
    );
  }
}
