class WasteBin {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final BinType type;
  final double fillLevel; // 0.0 to 1.0
  final BinStatus status;
  final DateTime lastUpdated;
  final DateTime lastCollected;
  final List<WasteType> wasteTypes;
  final double capacity; // in liters
  final String zone;
  final int priority; // 1-5, 5 being highest priority

  WasteBin({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.type,
    required this.fillLevel,
    required this.status,
    required this.lastUpdated,
    required this.lastCollected,
    required this.wasteTypes,
    required this.capacity,
    required this.zone,
    required this.priority,
  });

  factory WasteBin.fromJson(Map<String, dynamic> json) {
    return WasteBin(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
      type: BinType.values.firstWhere((e) => e.name == json['type']),
      fillLevel: json['fillLevel'].toDouble(),
      status: BinStatus.values.firstWhere((e) => e.name == json['status']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      lastCollected: DateTime.parse(json['lastCollected']),
      wasteTypes: (json['wasteTypes'] as List)
          .map((e) => WasteType.values.firstWhere((w) => w.name == e))
          .toList(),
      capacity: json['capacity'].toDouble(),
      zone: json['zone'],
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'type': type.name,
      'fillLevel': fillLevel,
      'status': status.name,
      'lastUpdated': lastUpdated.toIso8601String(),
      'lastCollected': lastCollected.toIso8601String(),
      'wasteTypes': wasteTypes.map((e) => e.name).toList(),
      'capacity': capacity,
      'zone': zone,
      'priority': priority,
    };
  }

  WasteBin copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    BinType? type,
    double? fillLevel,
    BinStatus? status,
    DateTime? lastUpdated,
    DateTime? lastCollected,
    List<WasteType>? wasteTypes,
    double? capacity,
    String? zone,
    int? priority,
  }) {
    return WasteBin(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      type: type ?? this.type,
      fillLevel: fillLevel ?? this.fillLevel,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      lastCollected: lastCollected ?? this.lastCollected,
      wasteTypes: wasteTypes ?? this.wasteTypes,
      capacity: capacity ?? this.capacity,
      zone: zone ?? this.zone,
      priority: priority ?? this.priority,
    );
  }
}

enum BinType {
  organic,
  recyclable,
  hazardous,
  mixed,
  electronic,
}

enum BinStatus {
  normal,
  full,
  overflowing,
  maintenance,
  offline,
}

enum WasteType {
  plastic,
  paper,
  glass,
  metal,
  organic,
  electronic,
  hazardous,
  textile,
  other,
}
