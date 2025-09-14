import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';
import '../models/alert.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final bins = dataService.wasteBins;
        final alerts = dataService.alerts;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context),
              const SizedBox(height: 24),
              
              // Key Metrics Cards
              _buildMetricsCards(context, bins),
              
              const SizedBox(height: 24),
              
              // Recent Alerts
              _buildRecentAlerts(context, alerts),
              
              const SizedBox(height: 24),
              
              // Quick Stats
              _buildQuickStats(context, bins),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to SwachhGrid',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI-Powered Smart Waste Management',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                'Last updated: ${_getCurrentTime()}',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards(BuildContext context, List<WasteBin> bins) {
    final totalBins = bins.length;
    final fullBins = bins.where((b) => b.fillLevel > 0.8).length;
    final overflowBins = bins.where((b) => b.fillLevel > 0.95).length;
    final averageFillLevel = bins.isEmpty 
        ? 0.0 
        : bins.map((b) => b.fillLevel).reduce((a, b) => a + b) / bins.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Metrics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard(
              context,
              'Total Bins',
              totalBins.toString(),
              Icons.delete_outline,
              Colors.blue,
            ),
            _buildMetricCard(
              context,
              'Full Bins',
              fullBins.toString(),
              Icons.warning,
              Colors.orange,
            ),
            _buildMetricCard(
              context,
              'Overflow Bins',
              overflowBins.toString(),
              Icons.error,
              Colors.red,
            ),
            _buildMetricCard(
              context,
              'Avg Fill Level',
              '${(averageFillLevel * 100).toInt()}%',
              Icons.pie_chart,
              Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAlerts(BuildContext context, List<Alert> alerts) {
    final recentAlerts = alerts.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Alerts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _viewAllAlerts(context),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentAlerts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('No recent alerts'),
              ),
            ),
          )
        else
          ...recentAlerts.map((alert) => _buildAlertCard(context, alert)),
      ],
    );
  }

  Widget _buildAlertCard(BuildContext context, Alert alert) {
    Color alertColor;
    IconData alertIcon;
    
    switch (alert.severity) {
      case AlertSeverity.critical:
        alertColor = Colors.red;
        alertIcon = Icons.error;
        break;
      case AlertSeverity.high:
        alertColor = Colors.orange;
        alertIcon = Icons.warning;
        break;
      case AlertSeverity.medium:
        alertColor = Colors.amber;
        alertIcon = Icons.info;
        break;
      case AlertSeverity.low:
        alertColor = Colors.blue;
        alertIcon = Icons.info_outline;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: alertColor.withOpacity(0.1),
          child: Icon(alertIcon, color: alertColor),
        ),
        title: Text(alert.title),
        subtitle: Text(alert.description),
        trailing: Text(
          _getTimeAgo(alert.createdAt),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        onTap: () => _showAlertDetails(context, alert),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, List<WasteBin> bins) {
    final zoneStats = <String, int>{};
    final typeStats = <String, int>{};
    
    for (final bin in bins) {
      zoneStats[bin.zone] = (zoneStats[bin.zone] ?? 0) + 1;
      typeStats[bin.type.name] = (typeStats[bin.type.name] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bins by Zone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...zoneStats.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text(entry.value.toString()),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bins by Type',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...typeStats.entries.map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.key),
                            Text(entry.value.toString()),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _viewAllAlerts(BuildContext context) {
    // TODO: Navigate to full alerts screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View all alerts functionality coming soon')),
    );
  }

  void _showAlertDetails(BuildContext context, Alert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.description),
            const SizedBox(height: 16),
            Text('Severity: ${alert.severity.name}'),
            Text('Status: ${alert.status.name}'),
            Text('Created: ${_getTimeAgo(alert.createdAt)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (alert.status == AlertStatus.active)
            ElevatedButton(
              onPressed: () {
                // TODO: Acknowledge alert
                Navigator.pop(context);
              },
              child: const Text('Acknowledge'),
            ),
        ],
      ),
    );
  }
}
