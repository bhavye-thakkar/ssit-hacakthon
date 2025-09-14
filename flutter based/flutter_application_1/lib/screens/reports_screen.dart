import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/mock_data_service.dart';
import '../models/alert.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report download started')),
              );
            },
          ),
        ],
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          final historicalData = mockDataService.historicalData;
          final alerts = mockDataService.alerts;
          final reports = mockDataService.reports;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Total Waste Collected',
                      '${historicalData.fold<double>(0, (sum, data) => sum + data.totalWasteCollected).toStringAsFixed(1)} kg',
                      Icons.delete_sweep,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Active Alerts',
                      '${alerts.where((alert) => alert.status == AlertStatus.active).length}',
                      Icons.warning,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Citizen Reports',
                      '${reports.length}',
                      Icons.report,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Efficiency Rate',
                      '${historicalData.isNotEmpty ? (historicalData.last.efficiency).toStringAsFixed(1) : '0.0'}%',
                      Icons.trending_up,
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Text(
                'Waste Collection Trends',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Waste Collection Chart
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: historicalData.asMap().entries.map((entry) {
                          return FlSpot(entry.key.toDouble(), entry.value.totalWasteCollected);
                        }).toList(),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'Recent Alerts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Recent Alerts List
              ...alerts.take(5).map((alert) => Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: Icon(
                    _getAlertIcon(alert.type),
                    color: _getAlertColor(alert.severity),
                  ),
                  title: Text(alert.title),
                  subtitle: Text(alert.description),
                  trailing: Text(
                    _getTimeAgo(alert.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              )),

              const SizedBox(height: 32),
              const Text(
                'Efficiency Metrics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Efficiency Metrics
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildMetricRow('Average Collection Time', '2.5 hours'),
                      const SizedBox(height: 8),
                      _buildMetricRow('Fuel Efficiency', '8.5 km/L'),
                      const SizedBox(height: 8),
                      _buildMetricRow('Route Optimization', '15% improvement'),
                      const SizedBox(height: 8),
                      _buildMetricRow('Bin Utilization', '78%'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating detailed report...')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate PDF Report'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  IconData _getAlertIcon(AlertType type) {
    switch (type) {
      case AlertType.binOverflow:
        return Icons.warning;
      case AlertType.binFull:
        return Icons.delete;
      case AlertType.maintenanceRequired:
        return Icons.build;
      default:
        return Icons.info;
    }
  }

  Color _getAlertColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.critical:
        return Colors.red;
      case AlertSeverity.high:
        return Colors.orange;
      case AlertSeverity.medium:
        return Colors.yellow;
      case AlertSeverity.low:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
