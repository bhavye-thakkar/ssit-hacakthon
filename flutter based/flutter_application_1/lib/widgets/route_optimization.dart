import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/mock_data_service.dart';
import '../models/collection_route.dart' as models;
import '../models/waste_bin.dart';

class RouteOptimization extends StatefulWidget {
  const RouteOptimization({super.key});

  @override
  State<RouteOptimization> createState() => _RouteOptimizationState();
}

class _RouteOptimizationState extends State<RouteOptimization>
    with TickerProviderStateMixin {
  late TabController _tabController;
  models.CollectionRoute? _selectedRoute;

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
        final routes = dataService.routes;
        final bins = dataService.wasteBins;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Route Optimization'),
            actions: [
              IconButton(
                icon: const Icon(Icons.auto_awesome),
                onPressed: () => _optimizeAllRoutes(),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _createNewRoute(),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.route), text: 'Routes'),
                Tab(icon: Icon(Icons.map), text: 'Map View'),
                Tab(icon: Icon(Icons.analytics), text: 'Performance'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildRoutesList(routes),
              _buildMapView(routes, bins),
              _buildPerformanceView(routes),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoutesList(List<models.CollectionRoute> routes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        return _buildRouteCard(route);
      },
    );
  }

  Widget _buildRouteCard(models.CollectionRoute route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: _buildRouteStatusIcon(route.status),
        title: Text(
          route.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Driver: ${route.assignedDriver}'),
            Text('Vehicle: ${route.assignedVehicle}'),
            Text('Scheduled: ${_formatDateTime(route.scheduledTime)}'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRouteMetrics(route),
                const SizedBox(height: 16),
                _buildRouteActions(route),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStatusIcon(models.RouteStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case models.RouteStatus.planned:
        color = Colors.blue;
        icon = Icons.schedule;
        break;
      case models.RouteStatus.inProgress:
        color = Colors.orange;
        icon = Icons.play_arrow;
        break;
      case models.RouteStatus.completed:
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case models.RouteStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        break;
      case models.RouteStatus.delayed:
        color = Colors.amber;
        icon = Icons.schedule;
        break;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildRouteMetrics(models.CollectionRoute route) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            'Distance',
            '${route.estimatedDistance.toStringAsFixed(1)} km',
            Icons.straighten,
            Colors.blue,
          ),
        ),
        Expanded(
          child: _buildMetricItem(
            'Duration',
            '${route.estimatedDuration.toInt()} min',
            Icons.access_time,
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildMetricItem(
            'Bins',
            route.binIds.length.toString(),
            Icons.delete_outline,
            Colors.orange,
          ),
        ),
        Expanded(
          child: _buildMetricItem(
            'Efficiency',
            '${route.fuelEfficiency.toStringAsFixed(1)} km/L',
            Icons.local_gas_station,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRouteActions(models.CollectionRoute route) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _optimizeRoute(route),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Optimize'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _viewRouteOnMap(route),
            icon: const Icon(Icons.map),
            label: const Text('View Map'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _editRoute(route),
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(List<models.CollectionRoute> routes, List<WasteBin> bins) {
    return Stack(
      children: [
        // Simple map background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[100]!,
                Colors.blue[50]!,
                Colors.green[50]!,
              ],
            ),
          ),
          child: CustomPaint(
            painter: RouteMapPainter(
              routes: _selectedRoute != null ? [_selectedRoute!] : routes,
              bins: bins,
            ),
            size: Size.infinite,
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: DropdownButton<models.CollectionRoute?>(
                value: _selectedRoute,
                hint: const Text('Select Route'),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<models.CollectionRoute?>(
                    value: null,
                    child: Text('All Routes'),
                  ),
                  ...routes.map((route) => DropdownMenuItem<models.CollectionRoute?>(
                    value: route,
                    child: Text(route.name),
                  )),
                ],
                onChanged: (route) {
                  setState(() {
                    _selectedRoute = route;
                  });
                },
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => _centerMapOnRoutes(),
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceView(List<models.CollectionRoute> routes) {
    final completedRoutes = routes.where((r) => r.status == models.RouteStatus.completed).toList();
    final avgDistance = completedRoutes.isEmpty
        ? 0.0
        : completedRoutes.map((r) => r.estimatedDistance).reduce((a, b) => a + b) / completedRoutes.length;
    final avgDuration = completedRoutes.isEmpty
        ? 0.0
        : completedRoutes.map((r) => r.estimatedDuration).reduce((a, b) => a + b) / completedRoutes.length;
    final avgEfficiency = completedRoutes.isEmpty
        ? 0.0
        : completedRoutes.map((r) => r.fuelEfficiency).reduce((a, b) => a + b) / completedRoutes.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route Performance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Performance Metrics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildPerformanceCard(
                'Avg Distance',
                '${avgDistance.toStringAsFixed(1)} km',
                Icons.straighten,
                Colors.blue,
              ),
              _buildPerformanceCard(
                'Avg Duration',
                '${avgDuration.toInt()} min',
                Icons.access_time,
                Colors.green,
              ),
              _buildPerformanceCard(
                'Avg Efficiency',
                '${avgEfficiency.toStringAsFixed(1)} km/L',
                Icons.local_gas_station,
                Colors.orange,
              ),
              _buildPerformanceCard(
                'Completed Routes',
                completedRoutes.length.toString(),
                Icons.check_circle,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Optimization History
          const Text(
            'Recent Optimizations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          ...routes.expand((route) => route.optimizations).take(10).map((optimization) =>
            _buildOptimizationCard(optimization)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String title, String value, IconData icon, Color color) {
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationCard(models.RouteOptimization optimization) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(Icons.auto_awesome, color: Colors.green),
        ),
        title: Text('${optimization.type.name} Optimization'),
        subtitle: Text('Applied ${_getTimeAgo(optimization.appliedAt)}'),
        trailing: Text(
          '+${optimization.improvement.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _centerMapOnRoutes() {
    // Simulate centering the map
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Map centered on routes')),
    );
  }

  void _optimizeRoute(models.CollectionRoute route) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Optimize Route'),
        content: const Text('This will optimize the route for better efficiency. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performRouteOptimization(route);
            },
            child: const Text('Optimize'),
          ),
        ],
      ),
    );
  }

  void _performRouteOptimization(models.CollectionRoute route) {
    // TODO: Implement actual route optimization algorithm
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route optimization in progress...')),
    );

    // Simulate optimization
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Route optimized! 15% improvement achieved.')),
      );
    });
  }

  void _optimizeAllRoutes() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Optimize All Routes'),
        content: const Text('This will optimize all routes for better efficiency. This may take a few minutes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performAllRouteOptimization();
            },
            child: const Text('Optimize All'),
          ),
        ],
      ),
    );
  }

  void _performAllRouteOptimization() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Optimizing all routes...')),
    );

    // TODO: Implement batch optimization
    Future.delayed(const Duration(seconds: 3), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All routes optimized! Average 12% improvement achieved.')),
      );
    });
  }

  void _viewRouteOnMap(models.CollectionRoute route) {
    setState(() {
      _selectedRoute = route;
      _tabController.animateTo(1); // Switch to map tab
    });
  }

  void _editRoute(models.CollectionRoute route) {
    // TODO: Implement route editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Route editing functionality coming soon')),
    );
  }

  void _createNewRoute() {
    // TODO: Implement new route creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New route creation functionality coming soon')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
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
}

class RouteMapPainter extends CustomPainter {
  final List<models.CollectionRoute> routes;
  final List<WasteBin> bins;

  RouteMapPainter({required this.routes, required this.bins});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw grid lines
    paint.color = Colors.grey.withOpacity(0.3);
    paint.strokeWidth = 1;

    for (int i = 0; i < 10; i++) {
      final x = (size.width / 10) * i;
      final y = (size.height / 10) * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw routes
    for (final route in routes) {
      _drawRoute(canvas, size, route);
    }
  }

  void _drawRoute(Canvas canvas, Size size, models.CollectionRoute route) {
    final paint = Paint();
    final routeColor = _getRouteColor(route);

    paint.color = routeColor;
    paint.strokeWidth = 4;
    paint.style = PaintingStyle.stroke;

    // Draw route line
    if (route.waypoints.length > 1) {
      final path = Path();
      bool isFirst = true;

      for (final waypoint in route.waypoints) {
        final x = (waypoint.longitude - 77.5) * size.width * 10;
        final y = (12.9 - waypoint.latitude) * size.height * 10;

        if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
          if (isFirst) {
            path.moveTo(x, y);
            isFirst = false;
          } else {
            path.lineTo(x, y);
          }
        }
      }

      canvas.drawPath(path, paint);
    }

    // Draw waypoints
    for (final waypoint in route.waypoints) {
      final x = (waypoint.longitude - 77.5) * size.width * 10;
      final y = (12.9 - waypoint.latitude) * size.height * 10;

      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        // Draw waypoint circle
        paint.color = routeColor;
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, y), 6, paint);

        // Draw waypoint border
        paint.color = Colors.white;
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 2;
        canvas.drawCircle(Offset(x, y), 6, paint);
      }
    }
  }

  Color _getRouteColor(models.CollectionRoute route) {
    switch (route.status) {
      case models.RouteStatus.planned:
        return Colors.blue;
      case models.RouteStatus.inProgress:
        return Colors.orange;
      case models.RouteStatus.completed:
        return Colors.green;
      case models.RouteStatus.cancelled:
        return Colors.red;
      case models.RouteStatus.delayed:
        return Colors.amber;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}