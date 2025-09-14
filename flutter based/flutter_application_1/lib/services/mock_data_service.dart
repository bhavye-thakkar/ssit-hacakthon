import 'dart:math';
import 'package:flutter/material.dart';
import '../models/waste_bin.dart';
import '../models/collection_route.dart';
import '../models/alert.dart';
import '../models/analytics.dart';
import '../models/citizen_report.dart';

class MockDataService extends ChangeNotifier {
  final List<WasteBin> _wasteBins = [];
  final List<CollectionRoute> _routes = [];
  final List<Alert> _alerts = [];
  final List<AnalyticsData> _analytics = [];
  final List<CitizenReport> _reports = [];
  final List<HistoricalData> _historicalData = [];

  MockDataService() {
    _initializeMockData();
    _startRealTimeUpdates();
  }

  List<WasteBin> get wasteBins => List.unmodifiable(_wasteBins);
  List<Alert> get alerts => List.unmodifiable(_alerts);
  List<CollectionRoute> get routes => List.unmodifiable(_routes);
  List<AnalyticsData> get analytics => List.unmodifiable(_analytics);
  List<CitizenReport> get reports => List.unmodifiable(_reports);
  List<HistoricalData> get historicalData => List.unmodifiable(_historicalData);

  void _initializeMockData() {
    // Initialize mock waste bins
    _wasteBins.addAll(_generateMockBins());
    
    // Initialize mock routes
    _routes.addAll(_generateMockRoutes());
    
    // Initialize mock alerts
    _alerts.addAll(_generateMockAlerts());
    
    // Initialize mock analytics
    _analytics.addAll(_generateMockAnalytics());
    
    // Initialize mock historical data
    _historicalData.addAll(_generateMockHistoricalData());
    
    // Initialize mock citizen reports
    _reports.addAll(_generateMockReports());
  }

  void _startRealTimeUpdates() {
    // Simulate real-time updates every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      _updateRealTimeData();
      _startRealTimeUpdates();
    });
  }

  void _updateRealTimeData() {
    final random = Random();
    
    // Update bin fill levels
    for (int i = 0; i < _wasteBins.length; i++) {
      final bin = _wasteBins[i];
      final change = (random.nextDouble() - 0.5) * 0.1; // ±5% change
      final newFillLevel = (bin.fillLevel + change).clamp(0.0, 1.0);
      
      _wasteBins[i] = bin.copyWith(
        fillLevel: newFillLevel,
        lastUpdated: DateTime.now(),
        status: _getBinStatus(newFillLevel),
      );
    }
    
    // Generate new alerts occasionally
    if (random.nextDouble() < 0.1) { // 10% chance
      _generateRandomAlert();
    }
    
    // Update analytics
    _updateAnalytics();
    
    notifyListeners();
  }

  void _updateAnalytics() {
    final now = DateTime.now();
    final analyticsData = AnalyticsData(
      id: 'analytics_${now.millisecondsSinceEpoch}',
      type: AnalyticsType.fillLevel,
      timestamp: now,
      data: {
        'averageFillLevel': _wasteBins.map((b) => b.fillLevel).reduce((a, b) => a + b) / _wasteBins.length,
        'totalBins': _wasteBins.length,
        'fullBins': _wasteBins.where((b) => b.fillLevel > 0.8).length,
        'overflowBins': _wasteBins.where((b) => b.fillLevel > 0.95).length,
      },
    );
    
    _analytics.add(analyticsData);
    
    // Keep only last 1000 analytics entries
    if (_analytics.length > 1000) {
      _analytics.removeRange(0, _analytics.length - 1000);
    }
  }

  void _generateRandomAlert() {
    final random = Random();
    final bin = _wasteBins[random.nextInt(_wasteBins.length)];
    
    final alertTypes = [
      AlertType.binOverflow,
      AlertType.binFull,
      AlertType.maintenanceRequired,
    ];
    
    final alertType = alertTypes[random.nextInt(alertTypes.length)];
    
    final alert = Alert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      type: alertType,
      severity: _getAlertSeverity(alertType, bin.fillLevel),
      title: _getAlertTitle(alertType),
      description: _getAlertDescription(alertType, bin),
      binId: bin.id,
      createdAt: DateTime.now(),
      status: AlertStatus.active,
      metadata: {
        'fillLevel': bin.fillLevel,
        'location': bin.address,
      },
      assignedTo: [],
    );
    
    _alerts.add(alert);
  }

  AlertSeverity _getAlertSeverity(AlertType type, double fillLevel) {
    switch (type) {
      case AlertType.binOverflow:
        return AlertSeverity.critical;
      case AlertType.binFull:
        return fillLevel > 0.9 ? AlertSeverity.high : AlertSeverity.medium;
      case AlertType.maintenanceRequired:
        return AlertSeverity.medium;
      default:
        return AlertSeverity.low;
    }
  }

  String _getAlertTitle(AlertType type) {
    switch (type) {
      case AlertType.binOverflow:
        return 'Bin Overflow Detected';
      case AlertType.binFull:
        return 'Bin is Full';
      case AlertType.maintenanceRequired:
        return 'Maintenance Required';
      default:
        return 'Alert';
    }
  }

  String _getAlertDescription(AlertType type, WasteBin bin) {
    switch (type) {
      case AlertType.binOverflow:
        return 'Waste bin at ${bin.address} is overflowing and needs immediate attention.';
      case AlertType.binFull:
        return 'Waste bin at ${bin.address} is ${(bin.fillLevel * 100).toInt()}% full and should be collected soon.';
      case AlertType.maintenanceRequired:
        return 'Waste bin at ${bin.address} requires maintenance.';
      default:
        return 'Alert for bin at ${bin.address}';
    }
  }

  BinStatus _getBinStatus(double fillLevel) {
    if (fillLevel > 0.95) return BinStatus.overflowing;
    if (fillLevel > 0.8) return BinStatus.full;
    return BinStatus.normal;
  }

  List<WasteBin> _generateMockBins() {
    final bins = <WasteBin>[];
    final random = Random();
    
    // Generate 50 mock bins across different zones
    for (int i = 0; i < 50; i++) {
      bins.add(WasteBin(
        id: 'bin_$i',
        name: 'Waste Bin ${i + 1}',
        latitude: 12.9716 + (random.nextDouble() - 0.5) * 0.1, // Around Bangalore
        longitude: 77.5946 + (random.nextDouble() - 0.5) * 0.1,
        address: 'Zone ${(i % 5) + 1}, Street ${i + 1}',
        type: BinType.values[random.nextInt(BinType.values.length)],
        fillLevel: random.nextDouble(),
        status: BinStatus.normal,
        lastUpdated: DateTime.now(),
        lastCollected: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
        wasteTypes: WasteType.values.take(random.nextInt(3) + 1).toList(),
        capacity: 100 + random.nextInt(200).toDouble(),
        zone: 'Zone ${(i % 5) + 1}',
        priority: random.nextInt(5) + 1,
      ));
    }
    
    return bins;
  }

  List<CollectionRoute> _generateMockRoutes() {
    final routes = <CollectionRoute>[];
    final random = Random();
    
    for (int i = 0; i < 10; i++) {
      final binIds = _wasteBins.skip(i * 5).take(5).map((b) => b.id).toList();
      final waypoints = binIds.map((binId) {
        final bin = _wasteBins.firstWhere((b) => b.id == binId);
        return RoutePoint(
          latitude: bin.latitude,
          longitude: bin.longitude,
          binId: binId,
          order: binIds.indexOf(binId),
          status: PointStatus.pending,
        );
      }).toList();
      
      routes.add(CollectionRoute(
        id: 'route_$i',
        name: 'Route ${i + 1}',
        binIds: binIds,
        waypoints: waypoints,
        scheduledTime: DateTime.now().add(Duration(hours: i)),
        status: RouteStatus.planned,
        assignedDriver: 'Driver ${i + 1}',
        assignedVehicle: 'Vehicle ${i + 1}',
        estimatedDuration: 60 + random.nextInt(120).toDouble(),
        estimatedDistance: 10 + random.nextInt(30).toDouble(),
        fuelEfficiency: 8 + random.nextInt(4).toDouble(),
        createdAt: DateTime.now(),
        optimizations: [
          if (random.nextBool()) 
            RouteOptimization(
              id: 'opt_${i}_1',
              type: OptimizationType.distance,
              improvement: random.nextDouble() * 10,
              parameters: {'algorithm': 'dijkstra'},
              appliedAt: DateTime.now().subtract(Duration(days: random.nextInt(5))),
            ),
          if (random.nextBool()) 
            RouteOptimization(
              id: 'opt_${i}_2',
              type: OptimizationType.time,
              improvement: random.nextDouble() * 15,
              parameters: {'traffic': 'real-time'},
              appliedAt: DateTime.now().subtract(Duration(days: random.nextInt(10))),
            ),
        ],
      ));
    }
    
    return routes;
  }

  List<Alert> _generateMockAlerts() {
    final alerts = <Alert>[];
    final random = Random();
    
    for (int i = 0; i < 5; i++) {
      final bin = _wasteBins[random.nextInt(_wasteBins.length)];
      alerts.add(Alert(
        id: 'alert_$i',
        type: AlertType.binFull,
        severity: AlertSeverity.medium,
        title: 'Bin is Full',
        description: 'Waste bin at ${bin.address} is ${(bin.fillLevel * 100).toInt()}% full.',
        binId: bin.id,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
        status: AlertStatus.active,
        metadata: {'fillLevel': bin.fillLevel},
        assignedTo: [],
      ));
    }
    
    return alerts;
  }

  List<AnalyticsData> _generateMockAnalytics() {
    final analytics = <AnalyticsData>[];
    final random = Random();
    
    for (int i = 0; i < 100; i++) {
      analytics.add(AnalyticsData(
        id: 'analytics_$i',
        type: AnalyticsType.fillLevel,
        timestamp: DateTime.now().subtract(Duration(hours: i)),
        data: {
          'averageFillLevel': random.nextDouble(),
          'totalBins': _wasteBins.length,
          'fullBins': random.nextInt(10),
        },
      ));
    }
    
    return analytics;
  }

  List<HistoricalData> _generateMockHistoricalData() {
    final historical = <HistoricalData>[];
    final random = Random();
    
    for (int i = 0; i < 30; i++) {
      historical.add(HistoricalData(
        date: DateTime.now().subtract(Duration(days: i)),
        totalWasteCollected: 1000 + random.nextInt(2000).toDouble(),
        binsCollected: 20 + random.nextInt(30),
        totalDistance: 50 + random.nextInt(100).toDouble(),
        totalFuelUsed: 20 + random.nextInt(40).toDouble(),
        averageFillLevel: random.nextDouble(),
        alertsGenerated: random.nextInt(10),
        efficiency: 70 + random.nextInt(30).toDouble(),
        wasteTypeDistribution: {
          'plastic': random.nextDouble(),
          'paper': random.nextDouble(),
          'organic': random.nextDouble(),
        },
        zoneDistribution: {
          'Zone 1': random.nextDouble(),
          'Zone 2': random.nextDouble(),
          'Zone 3': random.nextDouble(),
        },
      ));
    }
    
    return historical;
  }

  List<CitizenReport> _generateMockReports() {
    final reports = <CitizenReport>[];
    final random = Random();
    
    for (int i = 0; i < 10; i++) {
      final bin = _wasteBins[random.nextInt(_wasteBins.length)];
      reports.add(CitizenReport(
        id: 'report_$i',
        citizenId: 'citizen_$i',
        citizenName: 'Citizen ${i + 1}',
        citizenEmail: 'citizen${i + 1}@example.com',
        citizenPhone: '+91${9000000000 + i}',
        type: ReportType.binOverflow,
        title: 'Bin Overflow Report',
        description: 'The waste bin is overflowing and needs immediate attention.',
        latitude: bin.latitude,
        longitude: bin.longitude,
        address: bin.address,
        imageUrls: [
          'https://picsum.photos/seed/${i + 1}/300/200',
          'https://picsum.photos/seed/${i + 2}/300/200',
        ],
        status: ReportStatus.submitted,
        priority: ReportPriority.medium,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
        updates: [],
        rating: 0.0,
      ));
    }
    
    return reports;
  }

  // Public methods for external access
  void acknowledgeAlert(String alertId, String userId) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        status: AlertStatus.acknowledged,
        acknowledgedAt: DateTime.now(),
        acknowledgedBy: userId,
      );
      notifyListeners();
    }
  }

  void resolveAlert(String alertId, String userId) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        status: AlertStatus.resolved,
        resolvedAt: DateTime.now(),
        resolvedBy: userId,
      );
      notifyListeners();
    }
  }

  void addCitizenReport(CitizenReport report) {
    _reports.add(report);
    notifyListeners();
  }
}
