class CitizenReport {
  final String id;
  final String citizenId;
  final String citizenName;
  final String citizenEmail;
  final String citizenPhone;
  final ReportType type;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final List<String> imageUrls;
  final ReportStatus status;
  final ReportPriority priority;
  final DateTime createdAt;
  final DateTime? assignedAt;
  final String? assignedTo;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolution;
  final List<ReportUpdate> updates;
  final double rating; // 1-5 stars
  final String? feedback;

  CitizenReport({
    required this.id,
    required this.citizenId,
    required this.citizenName,
    required this.citizenEmail,
    required this.citizenPhone,
    required this.type,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.imageUrls,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.assignedAt,
    this.assignedTo,
    this.resolvedAt,
    this.resolvedBy,
    this.resolution,
    required this.updates,
    required this.rating,
    this.feedback,
  });

  factory CitizenReport.fromJson(Map<String, dynamic> json) {
    return CitizenReport(
      id: json['id'],
      citizenId: json['citizenId'],
      citizenName: json['citizenName'],
      citizenEmail: json['citizenEmail'],
      citizenPhone: json['citizenPhone'],
      type: ReportType.values.firstWhere((e) => e.name == json['type']),
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      imageUrls: List<String>.from(json['imageUrls']),
      status: ReportStatus.values.firstWhere((e) => e.name == json['status']),
      priority: ReportPriority.values.firstWhere((e) => e.name == json['priority']),
      createdAt: DateTime.parse(json['createdAt']),
      assignedAt: json['assignedAt'] != null 
          ? DateTime.parse(json['assignedAt']) 
          : null,
      assignedTo: json['assignedTo'],
      resolvedAt: json['resolvedAt'] != null 
          ? DateTime.parse(json['resolvedAt']) 
          : null,
      resolvedBy: json['resolvedBy'],
      resolution: json['resolution'],
      updates: (json['updates'] as List)
          .map((e) => ReportUpdate.fromJson(e))
          .toList(),
      rating: json['rating']?.toDouble() ?? 0.0,
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'citizenId': citizenId,
      'citizenName': citizenName,
      'citizenEmail': citizenEmail,
      'citizenPhone': citizenPhone,
      'type': type.name,
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'imageUrls': imageUrls,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
      'assignedAt': assignedAt?.toIso8601String(),
      'assignedTo': assignedTo,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
      'resolution': resolution,
      'updates': updates.map((e) => e.toJson()).toList(),
      'rating': rating,
      'feedback': feedback,
    };
  }
}

class ReportUpdate {
  final String id;
  final String reportId;
  final String updatedBy;
  final String updateType;
  final String message;
  final DateTime timestamp;
  final List<String> attachments;

  ReportUpdate({
    required this.id,
    required this.reportId,
    required this.updatedBy,
    required this.updateType,
    required this.message,
    required this.timestamp,
    required this.attachments,
  });

  factory ReportUpdate.fromJson(Map<String, dynamic> json) {
    return ReportUpdate(
      id: json['id'],
      reportId: json['reportId'],
      updatedBy: json['updatedBy'],
      updateType: json['updateType'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: List<String>.from(json['attachments']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportId': reportId,
      'updatedBy': updatedBy,
      'updateType': updateType,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
    };
  }
}

enum ReportType {
  binOverflow,
  binMissing,
  binDamaged,
  illegalDumping,
  collectionMissed,
  routeIssue,
  generalComplaint,
  suggestion,
  appreciation,
}

enum ReportStatus {
  submitted,
  underReview,
  assigned,
  inProgress,
  resolved,
  closed,
  rejected,
}

enum ReportPriority {
  low,
  medium,
  high,
  urgent,
}
