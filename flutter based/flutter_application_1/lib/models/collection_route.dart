class CollectionRoute {
  final String id;
  final String name;
  final List<String> binIds;
  final List<RoutePoint> waypoints;
  final DateTime scheduledTime;
  final RouteStatus status;
  final String assignedDriver;
  final String assignedVehicle;
  final double estimatedDuration; // in minutes
  final double estimatedDistance; // in kilometers
  final double fuelEfficiency; // km/liter
  final DateTime createdAt;
  final DateTime? completedAt;
  final List<RouteOptimization> optimizations;

  CollectionRoute({
    required this.id,
    required this.name,
    required this.binIds,
    required this.waypoints,
    required this.scheduledTime,
    required this.status,
    required this.assignedDriver,
    required this.assignedVehicle,
    required this.estimatedDuration,
    required this.estimatedDistance,
    required this.fuelEfficiency,
    required this.createdAt,
    this.completedAt,
    required this.optimizations,
  });

  factory CollectionRoute.fromJson(Map<String, dynamic> json) {
    return CollectionRoute(
      id: json['id'],
      name: json['name'],
      binIds: List<String>.from(json['binIds']),
      waypoints: (json['waypoints'] as List)
          .map((e) => RoutePoint.fromJson(e))
          .toList(),
      scheduledTime: DateTime.parse(json['scheduledTime']),
      status: RouteStatus.values.firstWhere((e) => e.name == json['status']),
      assignedDriver: json['assignedDriver'],
      assignedVehicle: json['assignedVehicle'],
      estimatedDuration: json['estimatedDuration'].toDouble(),
      estimatedDistance: json['estimatedDistance'].toDouble(),
      fuelEfficiency: json['fuelEfficiency'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      optimizations: (json['optimizations'] as List)
          .map((e) => RouteOptimization.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'binIds': binIds,
      'waypoints': waypoints.map((e) => e.toJson()).toList(),
      'scheduledTime': scheduledTime.toIso8601String(),
      'status': status.name,
      'assignedDriver': assignedDriver,
      'assignedVehicle': assignedVehicle,
      'estimatedDuration': estimatedDuration,
      'estimatedDistance': estimatedDistance,
      'fuelEfficiency': fuelEfficiency,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'optimizations': optimizations.map((e) => e.toJson()).toList(),
    };
  }
}

class RoutePoint {
  final double latitude;
  final double longitude;
  final String? binId;
  final int order;
  final DateTime? estimatedArrival;
  final DateTime? actualArrival;
  final PointStatus status;

  RoutePoint({
    required this.latitude,
    required this.longitude,
    this.binId,
    required this.order,
    this.estimatedArrival,
    this.actualArrival,
    required this.status,
  });

  factory RoutePoint.fromJson(Map<String, dynamic> json) {
    return RoutePoint(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      binId: json['binId'],
      order: json['order'],
      estimatedArrival: json['estimatedArrival'] != null 
          ? DateTime.parse(json['estimatedArrival']) 
          : null,
      actualArrival: json['actualArrival'] != null 
          ? DateTime.parse(json['actualArrival']) 
          : null,
      status: PointStatus.values.firstWhere((e) => e.name == json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'binId': binId,
      'order': order,
      'estimatedArrival': estimatedArrival?.toIso8601String(),
      'actualArrival': actualArrival?.toIso8601String(),
      'status': status.name,
    };
  }
}

class RouteOptimization {
  final String id;
  final OptimizationType type;
  final double improvement; // percentage improvement
  final Map<String, dynamic> parameters;
  final DateTime appliedAt;

  RouteOptimization({
    required this.id,
    required this.type,
    required this.improvement,
    required this.parameters,
    required this.appliedAt,
  });

  factory RouteOptimization.fromJson(Map<String, dynamic> json) {
    return RouteOptimization(
      id: json['id'],
      type: OptimizationType.values.firstWhere((e) => e.name == json['type']),
      improvement: json['improvement'].toDouble(),
      parameters: json['parameters'],
      appliedAt: DateTime.parse(json['appliedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'improvement': improvement,
      'parameters': parameters,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }
}

enum RouteStatus {
  planned,
  inProgress,
  completed,
  cancelled,
  delayed,
}

enum PointStatus {
  pending,
  inProgress,
  completed,
  skipped,
}

enum OptimizationType {
  distance,
  time,
  fuel,
  priority,
  traffic,
}

