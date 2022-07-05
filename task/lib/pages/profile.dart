import 'package:flutter/material.dart';
import 'package:task/widgets/bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigatorBar(context, 3),
      body: Container(
        child: Text("data"),
      ),
    );
  }
}
