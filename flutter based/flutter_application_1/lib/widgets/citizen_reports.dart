import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/citizen_report.dart';

class CitizenReports extends StatefulWidget {
  const CitizenReports({super.key});

  @override
  State<CitizenReports> createState() => _CitizenReportsState();
}

class _CitizenReportsState extends State<CitizenReports>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        final reports = dataService.reports;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Citizen Reports'),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterDialog,
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _refreshReports(),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.report), text: 'All Reports'),
                Tab(icon: Icon(Icons.pending), text: 'Pending'),
                Tab(icon: Icon(Icons.work), text: 'In Progress'),
                Tab(icon: Icon(Icons.check_circle), text: 'Resolved'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildReportsList(reports),
              _buildReportsList(reports.where((r) => r.status == ReportStatus.submitted).toList()),
              _buildReportsList(reports.where((r) => r.status == ReportStatus.inProgress).toList()),
              _buildReportsList(reports.where((r) => r.status == ReportStatus.resolved).toList()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _createNewReport(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildReportsList(List<CitizenReport> reports) {
    final filteredReports = _filterReports(reports);

    if (filteredReports.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No reports found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        final report = filteredReports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(CitizenReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: _buildReportTypeIcon(report.type),
        title: Text(
          report.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('By: ${report.citizenName}'),
            Text('Location: ${report.address}'),
            Row(
              children: [
                _buildStatusChip(report.status),
                const SizedBox(width: 8),
                _buildPriorityChip(report.priority),
                const Spacer(),
                Text(
                  _getTimeAgo(report.createdAt),
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
                Text(
                  'Description:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(report.description),
                const SizedBox(height: 16),
                
                // Report Details
                _buildDetailRow('Report ID', report.id),
                _buildDetailRow('Type', report.type.name),
                _buildDetailRow('Priority', report.priority.name),
                _buildDetailRow('Status', report.status.name),
                _buildDetailRow('Created', _formatDateTime(report.createdAt)),
                if (report.assignedAt != null)
                  _buildDetailRow('Assigned', _formatDateTime(report.assignedAt!)),
                if (report.resolvedAt != null)
                  _buildDetailRow('Resolved', _formatDateTime(report.resolvedAt!)),
                _buildDetailRow('Contact', report.citizenPhone),
                _buildDetailRow('Email', report.citizenEmail),
                
                const SizedBox(height: 16),
                
                // Images
                if (report.imageUrls.isNotEmpty) ...[
                  const Text(
                    'Images:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: report.imageUrls.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              report.imageUrls[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Updates
                if (report.updates.isNotEmpty) ...[
                  const Text(
                    'Updates:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...report.updates.map((update) => _buildUpdateCard(update)),
                  const SizedBox(height: 16),
                ],
                
                // Action Buttons
                _buildActionButtons(report),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeIcon(ReportType type) {
    Color color;
    IconData icon;
    
    switch (type) {
      case ReportType.binOverflow:
        color = Colors.red;
        icon = Icons.error;
        break;
      case ReportType.binMissing:
        color = Colors.orange;
        icon = Icons.location_off;
        break;
      case ReportType.binDamaged:
        color = Colors.amber;
        icon = Icons.build;
        break;
      case ReportType.illegalDumping:
        color = Colors.purple;
        icon = Icons.warning;
        break;
      case ReportType.collectionMissed:
        color = Colors.blue;
        icon = Icons.schedule;
        break;
      case ReportType.routeIssue:
        color = Colors.teal;
        icon = Icons.route;
        break;
      case ReportType.generalComplaint:
        color = Colors.grey;
        icon = Icons.comment;
        break;
      case ReportType.suggestion:
        color = Colors.green;
        icon = Icons.lightbulb;
        break;
      case ReportType.appreciation:
        color = Colors.pink;
        icon = Icons.favorite;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildStatusChip(ReportStatus status) {
    Color color;
    switch (status) {
      case ReportStatus.submitted:
        color = Colors.blue;
        break;
      case ReportStatus.underReview:
        color = Colors.orange;
        break;
      case ReportStatus.assigned:
        color = Colors.purple;
        break;
      case ReportStatus.inProgress:
        color = Colors.amber;
        break;
      case ReportStatus.resolved:
        color = Colors.green;
        break;
      case ReportStatus.closed:
        color = Colors.grey;
        break;
      case ReportStatus.rejected:
        color = Colors.red;
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

  Widget _buildPriorityChip(ReportPriority priority) {
    Color color;
    switch (priority) {
      case ReportPriority.low:
        color = Colors.green;
        break;
      case ReportPriority.medium:
        color = Colors.orange;
        break;
      case ReportPriority.high:
        color = Colors.red;
        break;
      case ReportPriority.urgent:
        color = Colors.purple;
        break;
    }

    return Chip(
      label: Text(
        priority.name.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
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

  Widget _buildUpdateCard(ReportUpdate update) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.update, color: Colors.blue),
        ),
        title: Text(update.updateType),
        subtitle: Text(update.message),
        trailing: Text(
          _getTimeAgo(update.timestamp),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildActionButtons(CitizenReport report) {
    return Row(
      children: [
        if (report.status == ReportStatus.submitted) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _assignReport(report),
              icon: const Icon(Icons.assignment),
              label: const Text('Assign'),
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (report.status == ReportStatus.assigned) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _startProgress(report),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
            ),
          ),
          const SizedBox(width: 8),
        ],
        if (report.status == ReportStatus.inProgress) ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _resolveReport(report),
              icon: const Icon(Icons.check),
              label: const Text('Resolve'),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _addUpdate(report),
            icon: const Icon(Icons.add_comment),
            label: const Text('Update'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewOnMap(report),
            icon: const Icon(Icons.map),
            label: const Text('Map'),
          ),
        ),
      ],
    );
  }

  List<CitizenReport> _filterReports(List<CitizenReport> reports) {
    if (_selectedFilter == 'all') return reports;

    return reports.where((report) {
      switch (_selectedFilter) {
        case 'overflow':
          return report.type == ReportType.binOverflow;
        case 'missing':
          return report.type == ReportType.binMissing;
        case 'damaged':
          return report.type == ReportType.binDamaged;
        case 'dumping':
          return report.type == ReportType.illegalDumping;
        case 'collection':
          return report.type == ReportType.collectionMissed;
        case 'route':
          return report.type == ReportType.routeIssue;
        case 'complaint':
          return report.type == ReportType.generalComplaint;
        case 'suggestion':
          return report.type == ReportType.suggestion;
        case 'appreciation':
          return report.type == ReportType.appreciation;
        case 'urgent':
          return report.priority == ReportPriority.urgent;
        case 'high':
          return report.priority == ReportPriority.high;
        default:
          return true;
      }
    }).toList();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('all', 'All Reports'),
              _buildFilterOption('overflow', 'Bin Overflow'),
              _buildFilterOption('missing', 'Missing Bins'),
              _buildFilterOption('damaged', 'Damaged Bins'),
              _buildFilterOption('dumping', 'Illegal Dumping'),
              _buildFilterOption('collection', 'Collection Issues'),
              _buildFilterOption('route', 'Route Issues'),
              _buildFilterOption('complaint', 'General Complaints'),
              _buildFilterOption('suggestion', 'Suggestions'),
              _buildFilterOption('appreciation', 'Appreciation'),
              _buildFilterOption('urgent', 'Urgent Priority'),
              _buildFilterOption('high', 'High Priority'),
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

  void _refreshReports() {
    // TODO: Implement refresh functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing reports...')),
    );
  }

  void _createNewReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Report'),
        content: const Text('New report creation functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _assignReport(CitizenReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Report'),
        content: const Text('Report assignment functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _startProgress(CitizenReport report) {
    // TODO: Implement start progress functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report marked as in progress')),
    );
  }

  void _resolveReport(CitizenReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Report'),
        content: const Text('Report resolution functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addUpdate(CitizenReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Update'),
        content: const Text('Add update functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewOnMap(CitizenReport report) {
    // TODO: Implement view on map functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View on map functionality coming soon')),
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
