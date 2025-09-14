import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_data_service.dart';
import '../models/citizen_report.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _addUser,
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _addUser() {
    if (_nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty) {

      final mockDataService = Provider.of<MockDataService>(context, listen: false);

      // Create a new citizen report as a user entry
      final newUser = CitizenReport(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        citizenId: 'citizen_${DateTime.now().millisecondsSinceEpoch}',
        citizenName: _nameController.text,
        citizenEmail: _emailController.text,
        citizenPhone: _phoneController.text,
        type: ReportType.binOverflow,
        title: 'User Registration',
        description: 'New user registered in the system',
        latitude: 12.9716,
        longitude: 77.5946,
        address: 'User Location',
        imageUrls: [],
        status: ReportStatus.submitted,
        priority: ReportPriority.medium,
        createdAt: DateTime.now(),
        updates: [],
        rating: 0.0,
      );

      mockDataService.addCitizenReport(newUser);

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddUserDialog,
          ),
        ],
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          // Get registered users from reports
          final registeredUsers = mockDataService.reports.where((report) =>
            report.title == 'User Registration'
          ).toList();

          // Add some predefined users
          final predefinedUsers = [
            {
              'name': 'Rajesh Kumar',
              'email': 'rajesh.kumar@email.com',
              'phone': '+91 9876543210',
              'role': 'Administrator',
            },
            {
              'name': 'Priya Sharma',
              'email': 'priya.sharma@email.com',
              'phone': '+91 9876543211',
              'role': 'Supervisor',
            },
            {
              'name': 'Amit Singh',
              'email': 'amit.singh@email.com',
              'phone': '+91 9876543212',
              'role': 'Driver',
            },
            {
              'name': 'Sneha Patel',
              'email': 'sneha.patel@email.com',
              'phone': '+91 9876543213',
              'role': 'Field Officer',
            },
            {
              'name': 'Vikram Rao',
              'email': 'vikram.rao@email.com',
              'phone': '+91 9876543214',
              'role': 'Technician',
            },
          ];

          final allUsers = [...predefinedUsers, ...registeredUsers.map((user) => {
            'name': user.citizenName,
            'email': user.citizenEmail,
            'phone': user.citizenPhone,
            'role': 'Citizen',
          })];

          return Column(
            children: [
              // Summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildUserStat('Total Users', allUsers.length.toString(), Colors.blue),
                    _buildUserStat('Predefined', predefinedUsers.length.toString(), Colors.green),
                    _buildUserStat('Registered', registeredUsers.length.toString(), Colors.orange),
                  ],
                ),
              ),

              // Users List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: allUsers.length,
                  itemBuilder: (context, index) {
                    final user = allUsers[index];
                    final isPredefined = index < predefinedUsers.length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isPredefined ? Colors.blue.shade500 : const Color(0xFF4CAF50),
                          child: Text(
                            user['name']![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(user['name']!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user['email']!),
                            Text(user['phone']!),
                            if (user['role'] != null)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isPredefined ? Colors.blue.shade100 : Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  user['role']!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isPredefined ? Colors.blue.shade800 : Colors.green.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        trailing: isPredefined
                            ? const Icon(Icons.verified, color: Colors.blue)
                            : IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Cannot delete predefined users')),
                                  );
                                },
                              ),
                      ),
                    ).animate()
                        .fadeIn(duration: const Duration(milliseconds: 600), delay: Duration(milliseconds: index * 50))
                        .slideX(begin: 0.1, end: 0);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}