import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoRouteOptimization = true;
  bool _realTimeTracking = true;
  bool _maintenanceAlerts = true;
  String _collectionFrequency = 'Daily';
  String _alertThreshold = '80%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management Settings'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'System Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Notifications
          Card(
            child: SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive alerts for bin status and maintenance'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),

          // Auto Route Optimization
          Card(
            child: SwitchListTile(
              title: const Text('Auto Route Optimization'),
              subtitle: const Text('Automatically optimize collection routes'),
              value: _autoRouteOptimization,
              onChanged: (value) {
                setState(() {
                  _autoRouteOptimization = value;
                });
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),

          // Real-time Tracking
          Card(
            child: SwitchListTile(
              title: const Text('Real-time Tracking'),
              subtitle: const Text('Enable GPS tracking for collection vehicles'),
              value: _realTimeTracking,
              onChanged: (value) {
                setState(() {
                  _realTimeTracking = value;
                });
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),

          // Maintenance Alerts
          Card(
            child: SwitchListTile(
              title: const Text('Maintenance Alerts'),
              subtitle: const Text('Get notified when bins need maintenance'),
              value: _maintenanceAlerts,
              onChanged: (value) {
                setState(() {
                  _maintenanceAlerts = value;
                });
              },
              activeColor: const Color(0xFF4CAF50),
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            'Collection Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Collection Frequency
          Card(
            child: ListTile(
              title: const Text('Collection Frequency'),
              subtitle: Text(_collectionFrequency),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showFrequencyDialog(),
            ),
          ),

          // Alert Threshold
          Card(
            child: ListTile(
              title: const Text('Bin Full Alert Threshold'),
              subtitle: Text(_alertThreshold),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showThresholdDialog(),
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            'Data Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Export Data
          Card(
            child: ListTile(
              title: const Text('Export Data'),
              subtitle: const Text('Download collection reports and analytics'),
              leading: const Icon(Icons.download, color: Colors.blue),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data export functionality coming soon')),
                );
              },
            ),
          ),

          // Clear Cache
          Card(
            child: ListTile(
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              leading: const Icon(Icons.cleaning_services, color: Colors.orange),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
            ),
          ),

          const SizedBox(height: 32),
          // Save Button
          ElevatedButton(
            onPressed: _saveSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save Settings',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Collection Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Daily', 'Twice Daily', 'Weekly', 'Custom']
              .map((frequency) => RadioListTile<String>(
                    title: Text(frequency),
                    value: frequency,
                    groupValue: _collectionFrequency,
                    onChanged: (value) {
                      setState(() {
                        _collectionFrequency = value!;
                      });
                      Navigator.of(context).pop();
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showThresholdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Threshold'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['70%', '80%', '90%', '95%']
              .map((threshold) => RadioListTile<String>(
                    title: Text(threshold),
                    value: threshold,
                    groupValue: _alertThreshold,
                    onChanged: (value) {
                      setState(() {
                        _alertThreshold = value!;
                      });
                      Navigator.of(context).pop();
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _saveSettings() {
    // In a real app, you'd save these settings to persistent storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }
}