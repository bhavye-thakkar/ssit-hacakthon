
import 'package:flutter/material.dart';

class CitizenPortalScreen extends StatelessWidget {
  const CitizenPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen Portal'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Gamification Section
          const Text('Your Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text('Points', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('1,250', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Rank', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('#42', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 40),
              Icon(Icons.verified, color: Colors.blue, size: 40),
              Icon(Icons.eco, color: Colors.green, size: 40),
            ],
          ),
          const SizedBox(height: 32),
          // Reporting Section
          const Text('Report an Issue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.report_problem),
            label: const Text('Report a Missed Bin'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Report Overflowing Bin'),
          ),
        ],
      ),
    );
  }
}
