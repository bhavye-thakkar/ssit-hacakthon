
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swachhgrid/screens/create_route_screen.dart';
import 'package:swachhgrid/screens/driver_schedule_screen.dart';
import 'package:swachhgrid/screens/active_bins_screen.dart';
import '../services/mock_data_service.dart';

class RoutesHubScreen extends StatelessWidget {
  const RoutesHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes Management'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text("Driver's Daily Schedule"),
            leading: const Icon(Icons.calendar_today),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DriverScheduleScreen()));
            },
          ),
          ListTile(
            title: const Text('Active Bins Monitoring'),
            leading: const Icon(Icons.monitor),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: Provider.of<MockDataService>(context, listen: false),
                  child: const ActiveBinsScreen(),
                ),
              ));
            },
          ),
        ],
      ),
    );
  }
}
