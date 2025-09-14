
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swachhgrid/screens/dashboard_screen.dart';
import 'package:swachhgrid/screens/routes_hub_screen.dart';
import 'package:swachhgrid/screens/analytics_screen.dart';
import 'package:swachhgrid/screens/citizen_portal_screen.dart';
import '../services/mock_data_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Consumer<MockDataService>(
      builder: (context, mockDataService, child) => AdminDashboardScreen(),
    ),
    Consumer<MockDataService>(
      builder: (context, mockDataService, child) => AnalyticsScreen(),
    ),
    Consumer<MockDataService>(
      builder: (context, mockDataService, child) => CitizenPortalScreen(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Citizens',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
