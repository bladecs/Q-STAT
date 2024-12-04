import 'package:flutter/material.dart';
import 'package:q_stat/home.dart';
import 'package:q_stat/setting.dart';
import 'package:q_stat/info.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class CustomStartDocked extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width * 0.083;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        53;
    return Offset(fabX, fabY);
  }
}

class CustomEndDocked extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width * 0.913 -
        scaffoldGeometry.floatingActionButtonSize.width;
    final double fabY = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        53;
    return Offset(fabX, fabY);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool isManualSelected = true;
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _fabIcon() {
    switch (_selectedIndex) {
      case 0:
        return Icons.settings;
      case 1:
        return Icons.home;
      case 2:
        return Icons.info;
      default:
        return Icons.home;
    }
  }

  void _fabAction() {
    switch (_selectedIndex) {
      case 0:
        print("Settings button pressed");
        break;
      case 1:
        print("Home button pressed");
        break;
      case 2:
        print("Info button pressed");
        break;
      default:
        print("Home button pressed");
    }
  }

  FloatingActionButtonLocation _fabLocation() {
    switch (_selectedIndex) {
      case 0:
        return CustomStartDocked();
      case 1:
        return FloatingActionButtonLocation.centerDocked;
      case 2:
        return CustomEndDocked();
      default:
        return FloatingActionButtonLocation.centerDocked;
    }
  }

  Widget _buildBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return const SettingPageDashboard();
      case 1:
        return const HomePageDashboard(); // Halaman utama
      case 2:
        return const InfoPageDashboard();
      default:
        return const HomePageDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBodyContent(),
      // Bottom navigation bar with animations on selection
      floatingActionButton: FloatingActionButton(
        onPressed: _fabAction,
        backgroundColor: Colors.white,
        child: Icon(
          _fabIcon(),
          color: Colors.purple[900],
          size: 30,
        ),
      ),
      floatingActionButtonLocation: _fabLocation(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color(0xFF0F031C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Icon Settings
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.settings ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  color: _selectedIndex == 0 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(0),
              ),
            ),
            const SizedBox(width: 0),

            // Icon Home
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.home ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 1 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(1),
              ),
            ),
            const SizedBox(width: 0), // Space for the FAB

            // Icon Info
            AnimatedOpacity(
              opacity: _fabIcon() == Icons.info ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: Icon(
                  Icons.info,
                  color: _selectedIndex == 2 ? Colors.white : Colors.grey,
                ),
                onPressed: () => _onItemTapped(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
