import 'package:flutter/material.dart';
import 'package:news_plus/screens/home_screen.dart';
import 'package:news_plus/screens/search_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.index,
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      showSelectedLabels: false,
      iconSize: 30,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withAlpha(100),
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
            icon: const Icon(Icons.home),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
            icon: const Icon(Icons.search),
          ),
          label: 'Search',
        ),
      ],
    );
  }
}
