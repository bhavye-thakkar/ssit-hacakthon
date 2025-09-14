import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class CleanlinessIssuesScreen extends StatelessWidget {
  const CleanlinessIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleanliness Issues'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh functionality could be added here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Refreshing data...')),
              );
            },
          ),
        ],
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          final bins = mockDataService.wasteBins;
          final cleanlinessIssues = bins.where((bin) =>
            bin.status == BinStatus.overflowing ||
            (bin.status == BinStatus.full && bin.fillLevel > 0.9)
          ).toList();

          return Column(
            children: [
              // Summary Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.blue.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      size: 48,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${cleanlinessIssues.length} Cleanliness Issues',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bins requiring immediate attention',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ).animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.1, end: 0),

              // Issues List
              Expanded(
                child: cleanlinessIssues.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'All bins are clean!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No cleanliness issues detected',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cleanlinessIssues.length,
                      itemBuilder: (context, index) {
                        final bin = cleanlinessIssues[index];
                        return _buildBinCard(bin, index);
                      },
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBinCard(WasteBin bin, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(bin.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(bin.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(bin.fillLevel * 100).toInt()}% Full',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(bin.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bin Name and Location
            Text(
              bin.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bin.address,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),

            // Coordinates
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.red.shade400),
                      const SizedBox(width: 8),
                      Text(
                        'Coordinates',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lat: ${bin.latitude.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Text(
                    'Lng: ${bin.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Schedule cleaning action
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule Cleaning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    // Navigate to map
                  },
                  icon: const Icon(Icons.map),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms, delay: (index * 100).ms)
        .slideX(begin: 0.1, end: 0);
  }

  Color _getStatusColor(BinStatus status) {
    switch (status) {
      case BinStatus.overflowing:
        return Colors.red;
      case BinStatus.full:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getStatusText(BinStatus status) {
    switch (status) {
      case BinStatus.overflowing:
        return 'OVERFLOWING';
      case BinStatus.full:
        return 'FULL';
      default:
        return 'NORMAL';
    }
  }
}