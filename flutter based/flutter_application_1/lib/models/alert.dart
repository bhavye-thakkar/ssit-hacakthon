class Alert {
  final String id;
  final AlertType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String? binId;
  final String? routeId;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final String? acknowledgedBy;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final AlertStatus status;
  final Map<String, dynamic> metadata;
  final List<String> assignedTo;

  Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    this.binId,
    this.routeId,
    required this.createdAt,
    this.acknowledgedAt,
    this.acknowledgedBy,
    this.resolvedAt,
    this.resolvedBy,
    required this.status,
    required this.metadata,
    required this.assignedTo,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      type: AlertType.values.firstWhere((e) => e.name == json['type']),
      severity: AlertSeverity.values.firstWhere((e) => e.name == json['severity']),
      title: json['title'],
      description: json['description'],
      binId: json['binId'],
      routeId: json['routeId'],
      createdAt: DateTime.parse(json['createdAt']),
      acknowledgedAt: json['acknowledgedAt'] != null 
          ? DateTime.parse(json['acknowledgedAt']) 
          : null,
      acknowledgedBy: json['acknowledgedBy'],
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt']) 
          : null,
      resolvedBy: json['resolvedBy'],
      status: AlertStatus.values.firstWhere((e) => e.name == json['status']),
      metadata: json['metadata'] ?? {},
      assignedTo: List<String>.from(json['assignedTo'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'severity': severity.name,
      'title': title,
      'description': description,
      'binId': binId,
      'routeId': routeId,
      'createdAt': createdAt.toIso8601String(),
      'acknowledgedAt': acknowledgedAt?.toIso8601String(),
      'acknowledgedBy': acknowledgedBy,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'status': status.name,
      'metadata': metadata,
      'assignedTo': assignedTo,
    };
  }

  Alert copyWith({
    String? id,
    AlertType? type,
    AlertSeverity? severity,
    String? title,
    String? description,
    String? binId,
    String? routeId,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
    String? acknowledgedBy,
    DateTime? resolvedAt,
    String? resolvedBy,
    AlertStatus? status,
    Map<String, dynamic>? metadata,
    List<String>? assignedTo,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      description: description ?? this.description,
      binId: binId ?? this.binId,
      routeId: routeId ?? this.routeId,
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: acknowledgedAt ?? this.acknowledgedAt,
      acknowledgedBy: acknowledgedBy ?? this.acknowledgedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      assignedTo: assignedTo ?? this.assignedTo,
    );
  }
}

enum AlertType {
  binOverflow,
  binFull,
  binOffline,
  routeDelay,
  vehicleBreakdown,
  maintenanceRequired,
  weatherWarning,
  trafficAlert,
  fuelLow,
  driverAlert,
  systemError,
  citizenReport,
}

enum AlertSeverity {
  low,
  medium,
  high,
  critical,
}

enum AlertStatus {
  active,
  acknowledged,
  resolved,
  dismissed,
}
