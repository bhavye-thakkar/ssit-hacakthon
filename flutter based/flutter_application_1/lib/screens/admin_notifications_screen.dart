
import 'package:flutter/material.dart';

class AdminNotificationsScreen extends StatelessWidget {
  const AdminNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF4CAF50),
          title: const Text('Notifications', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black87,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Routes'),
              Tab(text: 'Issues'),
              Tab(text: 'Breakdowns'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.visibility_off, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: const [
            NotificationItem(
              icon: Icons.alt_route,
              color: Colors.green,
              title: 'New Route Created',
              subtitle: 'Route 00 has been created.',
              time: 'Just now',
              isUnread: true,
            ),
            NotificationItem(
              icon: Icons.alt_route,
              color: Colors.green,
              title: 'New Route Assigned',
              subtitle: 'Route 01 has been assigned to Driver 2.',
              time: '5 minutes ago',
              isUnread: true,
            ),
            NotificationItem(
              icon: Icons.cleaning_services,
              color: Colors.blue,
              title: 'Resident Feedback',
              subtitle: 'A resident has reported a missed bin.',
              time: '14 hours ago',
            ),
             NotificationItem(
              icon: Icons.cleaning_services,
              color: Colors.blue,
              title: 'Issue Resolved',
              subtitle: 'The missed bin issue has been resolved.',
              time: '1 day ago',
            ),
             NotificationItem(
              icon: Icons.cleaning_services,
              color: Colors.blue,
              title: 'Issue Marked Resolved',
              subtitle: 'The overflowing bin has been marked as resolved.',
              time: '2 days ago',
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (isUnread)
            const Icon(Icons.circle, color: Colors.green, size: 8),
        ],
      ),
    );
  }
}
