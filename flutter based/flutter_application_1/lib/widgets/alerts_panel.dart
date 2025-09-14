import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/alert.dart';

class AlertsPanel extends StatefulWidget {
  const AlertsPanel({super.key});

  @override
  State<AlertsPanel> createState() => _AlertsPanelState();
}

class _AlertsPanelState extends State<AlertsPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MockDataService>(
      builder: (context, dataService, child) {
        final alerts = dataService.alerts;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Alerts & Notifications'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _refreshAlerts(),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Acknowledged'),
                Tab(text: 'Resolved'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAlertsList(alerts.where((a) => a.status == AlertStatus.active).toList()),
              _buildAlertsList(alerts.where((a) => a.status == AlertStatus.acknowledged).toList()),
              _buildAlertsList(alerts.where((a) => a.status == AlertStatus.resolved).toList()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createCustomAlert,
            child: const Icon(Icons.add_alert),
          ),
        );
      },
    );
  }

  Widget _buildAlertsList(List<Alert> alerts) {
    final filteredAlerts = _filterAlerts(alerts);

    if (filteredAlerts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No alerts found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAlerts.length,
      itemBuilder: (context, index) {
        final alert = filteredAlerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: _buildAlertIcon(alert),
        title: Text(
          alert.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.description),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildSeverityChip(alert.severity),
                const SizedBox(width: 8),
                _buildStatusChip(alert.status),
                const Spacer(),
                Text(
                  _getTimeAgo(alert.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Type', alert.type.name),
                _buildDetailRow('Severity', alert.severity.name),
                _buildDetailRow('Status', alert.status.name),
                _buildDetailRow('Created', _formatDateTime(alert.createdAt)),
                if (alert.acknowledgedAt != null)
                  _buildDetailRow('Acknowledged', _formatDateTime(alert.acknowledgedAt!)),
                if (alert.resolvedAt != null)
                  _buildDetailRow('Resolved', _formatDateTime(alert.resolvedAt!)),
                if (alert.binId != null)
                  _buildDetailRow('Bin ID', alert.binId!),
                if (alert.routeId != null)
                  _buildDetailRow('Route ID', alert.routeId!),
                const SizedBox(height: 16),
                _buildActionButtons(alert),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertIcon(Alert alert) {
    Color iconColor;
    IconData iconData;

    switch (alert.severity) {
      case AlertSeverity.critical:
        iconColor = Colors.red;
        iconData = Icons.error;
        break;
      case AlertSeverity.high:
        iconColor = Colors.orange;
        iconData = Icons.warning;
        break;
      case AlertSeverity.medium:
        iconColor = Colors.amber;
        iconData = Icons.info;
        break;
      case AlertSeverity.low:
        iconColor = Colors.blue;
        iconData = Icons.info_outline;
        break;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(iconData, color: iconColor),
    );
  }

  Widget _buildSeverityChip(AlertSeverity severity) {
    Color color;
    switch (severity) {
      case AlertSeverity.critical:
        color = Colors.red;
        break;
      case AlertSeverity.high:
        color = Colors.orange;
        break;
      case AlertSeverity.medium:
        color = Colors.amber;
        break;
      case AlertSeverity.low:
        color = Colors.blue;
        break;
    }

    return Chip(
      label: Text(
        severity.name.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatusChip(AlertStatus status) {
    Color color;
    switch (status) {
      case AlertStatus.active:
        color = Colors.red;
        break;
      case AlertStatus.acknowledged:
        color = Colors.orange;
        break;
      case AlertStatus.resolved:
        color = Colors.green;
        break;
      case AlertStatus.dismissed:
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(
        status.name.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Alert alert) {
    return Row(
      children: [
        if (alert.status == AlertStatus.active) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _acknowledgeAlert(alert),
              icon: const Icon(Icons.check),
              label: const Text('Acknowledge'),
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (alert.status == AlertStatus.acknowledged) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _resolveAlert(alert),
              icon: const Icon(Icons.done_all),
              label: const Text('Resolve'),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewAlertDetails(alert),
            icon: const Icon(Icons.visibility),
            label: const Text('Details'),
          ),
        ),
      ],
    );
  }

  List<Alert> _filterAlerts(List<Alert> alerts) {
    if (_selectedFilter == 'all') return alerts;

    return alerts.where((alert) {
      switch (_selectedFilter) {
        case 'critical':
          return alert.severity == AlertSeverity.critical;
        case 'high':
          return alert.severity == AlertSeverity.high;
        case 'medium':
          return alert.severity == AlertSeverity.medium;
        case 'low':
          return alert.severity == AlertSeverity.low;
        case 'bin':
          return alert.binId != null;
        case 'route':
          return alert.routeId != null;
        default:
          return true;
      }
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Alerts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('all', 'All Alerts'),
            _buildFilterOption('critical', 'Critical'),
            _buildFilterOption('high', 'High'),
            _buildFilterOption('medium', 'Medium'),
            _buildFilterOption('low', 'Low'),
            _buildFilterOption('bin', 'Bin Related'),
            _buildFilterOption('route', 'Route Related'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: _selectedFilter,
      onChanged: (value) {
        setState(() => _selectedFilter = value!);
        Navigator.pop(context);
      },
    );
  }

  void _refreshAlerts() {
    // TODO: Implement refresh functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing alerts...')),
    );
  }

  void _createCustomAlert() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Custom Alert'),
        content: const Text('Custom alert creation functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _acknowledgeAlert(Alert alert) {
    final dataService = Provider.of<MockDataService>(context, listen: false);
    dataService.acknowledgeAlert(alert.id, 'current_user');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert acknowledged')),
    );
  }

  void _resolveAlert(Alert alert) {
    final dataService = Provider.of<MockDataService>(context, listen: false);
    dataService.resolveAlert(alert.id, 'current_user');
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert resolved')),
    );
  }

  void _viewAlertDetails(Alert alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(alert.description),
              const SizedBox(height: 16),
              _buildDetailRow('Type', alert.type.name),
              _buildDetailRow('Severity', alert.severity.name),
              _buildDetailRow('Status', alert.status.name),
              _buildDetailRow('Created', _formatDateTime(alert.createdAt)),
              if (alert.acknowledgedAt != null)
                _buildDetailRow('Acknowledged', _formatDateTime(alert.acknowledgedAt!)),
              if (alert.resolvedAt != null)
                _buildDetailRow('Resolved', _formatDateTime(alert.resolvedAt!)),
              if (alert.binId != null)
                _buildDetailRow('Bin ID', alert.binId!),
              if (alert.routeId != null)
                _buildDetailRow('Route ID', alert.routeId!),
              if (alert.metadata.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Metadata:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...alert.metadata.entries.map((entry) => 
                  _buildDetailRow(entry.key, entry.value.toString())),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
