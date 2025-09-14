import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text('Welcome Admin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 11,
                top: 11,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: const Text(
                    '51',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Quick Stats
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Active Routes', value: '0', color: Colors.green)),
              SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Cleanliness Issues', value: '2', color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: StatCard(title: 'Breakdowns', value: '8', color: Colors.purple)),
              SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Special Requests', value: '0', color: Colors.pink)),
            ],
          ),
          const SizedBox(height: 32),
          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ActionCard(title: 'Create Route', icon: Icons.add_road, color: Colors.green)),
              SizedBox(width: 16),
              Expanded(child: ActionCard(title: 'View Reports', icon: Icons.bar_chart, color: Colors.orange)),
            ],
          ),
           const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(child: ActionCard(title: 'Users', icon: Icons.people, color: Colors.purple)),
              SizedBox(width: 16),
              Expanded(child: ActionCard(title: 'Settings', icon: Icons.settings, color: Colors.blue)),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF4CAF50),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0, // Home is active
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Truck',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Cleanliness',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash),
            label: 'Breakdown',
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StatCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ActionCard({super.key, required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}