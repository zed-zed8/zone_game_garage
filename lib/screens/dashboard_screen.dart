import 'package:flutter/material.dart';
import 'package:zone_game_garage/screens/pages/home_screen.dart';
import 'package:zone_game_garage/screens/pages/game_screen.dart';
import 'package:zone_game_garage/screens/pages/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this._screen});

  /// 'LoginScreen' or 'RegisterScreen'
  final Widget? _screen;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Track whether we are showing an external screen over the main tabs
  Widget? _overlayScreen;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomeScreen(), GameScreen(), ProfileScreen()];

    _overlayScreen = widget._screen;
  }

  @override
  Widget build(BuildContext context) {
    // If an overlay screen exists, show it; otherwise show the selected tab
    final Widget currentBody = _overlayScreen ?? _pages[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Zone Game Garage',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      body: currentBody,

      // Migrated to Material 3 NavigationBar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
            // Clear the overlay so the user can navigate back to standard tabs
            _overlayScreen = null;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.gamepad_outlined),
            selectedIcon: Icon(Icons.gamepad),
            label: 'Game',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
