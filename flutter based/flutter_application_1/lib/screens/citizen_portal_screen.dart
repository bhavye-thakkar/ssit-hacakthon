import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:swachhgrid/screens/report_submission_screen.dart';
import '../models/citizen_report.dart';

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
          const Text('Your Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(duration: 500.ms)
              .slideX(begin: -0.2, end: 0),
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
          ).animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
          const SizedBox(height: 16),
          const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideX(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 40),
              Icon(Icons.verified, color: Colors.blue, size: 40),
              Icon(Icons.eco, color: Colors.green, size: 40),
            ],
          ).animate()
              .fadeIn(duration: 800.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0),
          const SizedBox(height: 32),
          // Reporting Section
          const Text('Report an Issue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(duration: 500.ms, delay: 800.ms)
              .slideX(begin: -0.2, end: 0),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportSubmissionScreen(
                    reportType: ReportType.binMissing,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.report_problem),
            label: const Text('Report a Missed Bin'),
          ).animate()
              .fadeIn(duration: 600.ms, delay: 1000.ms)
              .slideX(begin: -0.1, end: 0),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportSubmissionScreen(
                    reportType: ReportType.binOverflow,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Report Overflowing Bin'),
          ).animate()
              .fadeIn(duration: 600.ms, delay: 1100.ms)
              .slideX(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}
