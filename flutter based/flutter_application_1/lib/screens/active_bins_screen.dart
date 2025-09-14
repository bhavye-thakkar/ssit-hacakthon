import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/waste_bin.dart';

class ActiveBinsScreen extends StatelessWidget {
  const ActiveBinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Bins Monitoring'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Consumer<MockDataService>(
        builder: (context, mockDataService, child) {
          final bins = mockDataService.wasteBins;
          final activeBins = bins.where((bin) =>
            bin.status != BinStatus.offline &&
            bin.status != BinStatus.maintenance
          ).toList();

          return Column(
            children: [
              // Summary Header
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.lightGreen.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem('Total Bins', bins.length.toString(), Colors.blue),
                    _buildSummaryItem('Active Bins', activeBins.length.toString(), Colors.green),
                    _buildSummaryItem('Full Bins', bins.where((b) => b.fillLevel > 0.8).length.toString(), Colors.orange),
                    _buildSummaryItem('Overflow', bins.where((b) => b.fillLevel > 0.95).length.toString(), Colors.red),
                  ],
                ),
              ),

              // Filter Tabs
              DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Normal'),
                        Tab(text: 'Full'),
                        Tab(text: 'Overflow'),
                      ],
                      labelColor: Color(0xFF4CAF50),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xFF4CAF50),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: TabBarView(
                        children: [
                          _buildBinsList(activeBins),
                          _buildBinsList(activeBins.where((b) => b.status == BinStatus.normal).toList()),
                          _buildBinsList(activeBins.where((b) => b.status == BinStatus.full).toList()),
                          _buildBinsList(activeBins.where((b) => b.status == BinStatus.overflowing).toList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
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
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBinsList(List<WasteBin> bins) {
    if (bins.isEmpty) {
      return const Center(
        child: Text('No bins in this category'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: bins.length,
      itemBuilder: (context, index) {
        final bin = bins[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(bin.status),
                shape: BoxShape.circle,
              ),
            ),
            title: Text(bin.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bin.address),
                const SizedBox(height: 2),
                Text(
                  'Lat: ${bin.latitude.toStringAsFixed(6)}, Lng: ${bin.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: bin.fillLevel,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(bin.status)),
                ),
                const SizedBox(height: 4),
                Text('${(bin.fillLevel * 100).toInt()}% full'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showBinDetails(context, bin),
            ),
          ),
        );
      },
    );
  }

  void _showBinDetails(BuildContext context, WasteBin bin) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bin.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Location: ${bin.address}'),
            const SizedBox(height: 8),
            Text('Coordinates: ${bin.latitude.toStringAsFixed(6)}, ${bin.longitude.toStringAsFixed(6)}'),
            const SizedBox(height: 8),
            Text('Type: ${bin.type.name}'),
            const SizedBox(height: 8),
            Text('Capacity: ${bin.capacity}L'),
            const SizedBox(height: 8),
            Text('Zone: ${bin.zone}'),
            const SizedBox(height: 8),
            Text('Priority: ${bin.priority}'),
            const SizedBox(height: 8),
            Text('Last Updated: ${_formatDate(bin.lastUpdated)}'),
            const SizedBox(height: 8),
            Text('Last Collected: ${_formatDate(bin.lastCollected)}'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Schedule collection
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Collection scheduled for ${bin.name}')),
                      );
                    },
                    icon: const Icon(Icons.schedule),
                    label: const Text('Schedule Collection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BinStatus status) {
    switch (status) {
      case BinStatus.normal:
        return Colors.green;
      case BinStatus.full:
        return Colors.orange;
      case BinStatus.overflowing:
        return Colors.red;
      case BinStatus.maintenance:
        return Colors.grey;
      case BinStatus.offline:
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}