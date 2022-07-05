import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:task/home_page.dart';
import 'package:task/pages/profile.dart';

buildBottomNavigatorBar(BuildContext context, d) {
  return ConvexAppBar(
    items: const [
      TabItem(icon: Icons.home, title: 'Home'),
      TabItem(icon: Icons.favorite, title: 'Favorite'),
      TabItem(icon: Icons.message, title: 'Message'),
      TabItem(icon: Icons.people, title: 'Profile'),
    ],
    initialActiveIndex: d,
    onTap: (int i) {
      switch (i) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
          break;
        default:
      }
      print('click index=$i');
    },
  );
}
