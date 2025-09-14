import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:swachhgrid/screens/users_screen.dart';
import 'package:swachhgrid/screens/settings_screen.dart';
import 'package:swachhgrid/screens/reports_screen.dart';
import 'package:swachhgrid/screens/map_screen.dart';
import 'package:swachhgrid/screens/active_bins_screen.dart';
import 'package:swachhgrid/screens/cleanliness_issues_screen.dart';
import 'package:swachhgrid/screens/special_requests_screen.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';
import '../models/citizen_report.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4CAF50),
        title: const Text('Welcome Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
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
          Consumer<MockDataService>(
            builder: (context, mockDataService, child) {
              final bins = mockDataService.wasteBins;
              final activeBins = bins.where((bin) =>
                bin.status != BinStatus.offline &&
                bin.status != BinStatus.maintenance
              ).length;
              final cleanlinessIssues = bins.where((bin) =>
                bin.status == BinStatus.overflowing ||
                (bin.status == BinStatus.full && bin.fillLevel > 0.9)
              ).length;
              final breakdowns = bins.where((bin) =>
                bin.status == BinStatus.maintenance
              ).length;
              final specialRequests = mockDataService.reports.where((report) =>
                report.type == ReportType.suggestion
              ).length;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: StatCard(
                        title: 'Active Bins',
                        value: activeBins.toString(),
                        color: Colors.green,
                        icon: Icons.inventory_2,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const ActiveBinsScreen(),
                          ));
                        },
                      ).animate()
                          .fadeIn(duration: 600.ms)
                          .slideX(begin: -0.2, end: 0)),
                      const SizedBox(width: 16),
                      Expanded(child: StatCard(
                        title: 'Cleanliness Issues',
                        value: cleanlinessIssues.toString(),
                        color: Colors.blue,
                        icon: Icons.cleaning_services,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const CleanlinessIssuesScreen(),
                          ));
                        },
                      ).animate()
                          .fadeIn(duration: 600.ms, delay: 200.ms)
                          .slideX(begin: 0.2, end: 0)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: StatCard(
                        title: 'Breakdowns',
                        value: breakdowns.toString(),
                        color: Colors.purple,
                        icon: Icons.build,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Breakdowns feature coming in next update')),
                          );
                        },
                      ).animate()
                          .fadeIn(duration: 600.ms, delay: 400.ms)
                          .slideX(begin: -0.2, end: 0)),
                      const SizedBox(width: 16),
                      Expanded(child: StatCard(
                        title: 'Special Requests',
                        value: specialRequests.toString(),
                        color: Colors.pink,
                        icon: Icons.star,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const SpecialRequestsScreen(),
                          ));
                        },
                      ).animate()
                          .fadeIn(duration: 600.ms, delay: 600.ms)
                          .slideX(begin: 0.2, end: 0)),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              .animate()
              .fadeIn(duration: 500.ms, delay: 800.ms),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ActionCard(
                title: 'View Map',
                icon: Icons.map,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Consumer<MockDataService>(
                      builder: (context, mockDataService, child) => const MapScreen(),
                    ),
                  ));
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 900.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))),
              const SizedBox(width: 16),
              Expanded(child: ActionCard(
                title: 'View Reports',
                icon: Icons.bar_chart,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Consumer<MockDataService>(
                      builder: (context, mockDataService, child) => const ReportsScreen(),
                    ),
                  ));
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))),
            ],
          ),
           const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ActionCard(
                title: 'Users',
                icon: Icons.people,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Consumer<MockDataService>(
                      builder: (context, mockDataService, child) => const UsersScreen(),
                    ),
                  ));
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 1100.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))),
              const SizedBox(width: 16),
              Expanded(child: ActionCard(
                title: 'Settings',
                icon: Icons.settings,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ));
                },
              ).animate()
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))),
            ],
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
  final IconData? icon;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
              ],
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}