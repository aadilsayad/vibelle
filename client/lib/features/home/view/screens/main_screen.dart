import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/features/home/view/screens/home_screen.dart';
import 'package:client/features/home/view/screens/search_screen.dart';
import 'package:client/features/home/view/screens/library_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 0;
  final screens = const [
    HomeScreen(),
    SearchScreen(),
    LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color: selectedIndex == 0
                  ? Palette.whiteColor
                  : Palette.inactiveBottomBarItemColor,
              width: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 1
                  ? 'assets/images/search_filled.png'
                  : 'assets/images/search_unfilled.png',
              color: selectedIndex == 1
                  ? Palette.whiteColor
                  : Palette.inactiveBottomBarItemColor,
              width: 30,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 2
                  ? 'assets/images/library_filled.png'
                  : 'assets/images/library_unfilled.png',
              color: selectedIndex == 2
                  ? Palette.whiteColor
                  : Palette.inactiveBottomBarItemColor,
              width: 30,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
