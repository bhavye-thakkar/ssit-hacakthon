class AnalyticsData {
  final String id;
  final AnalyticsType type;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final String? binId;
  final String? routeId;
  final String? zone;

  AnalyticsData({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.data,
    this.binId,
    this.routeId,
    this.zone,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      id: json['id'],
      type: AnalyticsType.values.firstWhere((e) => e.name == json['type']),
      timestamp: DateTime.parse(json['timestamp']),
      data: json['data'],
      binId: json['binId'],
      routeId: json['routeId'],
      zone: json['zone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'binId': binId,
      'routeId': routeId,
      'zone': zone,
    };
  }
}

class HistoricalData {
  final DateTime date;
  final double totalWasteCollected; // in kg
  final int binsCollected;
  final double totalDistance; // in km
  final double totalFuelUsed; // in liters
  final double averageFillLevel;
  final int alertsGenerated;
  final double efficiency; // percentage
  final Map<String, double> wasteTypeDistribution;
  final Map<String, double> zoneDistribution;

  HistoricalData({
    required this.date,
    required this.totalWasteCollected,
    required this.binsCollected,
    required this.totalDistance,
    required this.totalFuelUsed,
    required this.averageFillLevel,
    required this.alertsGenerated,
    required this.efficiency,
    required this.wasteTypeDistribution,
    required this.zoneDistribution,
  });

  factory HistoricalData.fromJson(Map<String, dynamic> json) {
    return HistoricalData(
      date: DateTime.parse(json['date']),
      totalWasteCollected: json['totalWasteCollected'].toDouble(),
      binsCollected: json['binsCollected'],
      totalDistance: json['totalDistance'].toDouble(),
      totalFuelUsed: json['totalFuelUsed'].toDouble(),
      averageFillLevel: json['averageFillLevel'].toDouble(),
      alertsGenerated: json['alertsGenerated'],
      efficiency: json['efficiency'].toDouble(),
      wasteTypeDistribution: Map<String, double>.from(json['wasteTypeDistribution']),
      zoneDistribution: Map<String, double>.from(json['zoneDistribution']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalWasteCollected': totalWasteCollected,
      'binsCollected': binsCollected,
      'totalDistance': totalDistance,
      'totalFuelUsed': totalFuelUsed,
      'averageFillLevel': averageFillLevel,
      'alertsGenerated': alertsGenerated,
      'efficiency': efficiency,
      'wasteTypeDistribution': wasteTypeDistribution,
      'zoneDistribution': zoneDistribution,
    };
  }
}

class PredictiveData {
  final String binId;
  final DateTime predictionDate;
  final double predictedFillLevel;
  final double confidence; // 0.0 to 1.0
  final List<PredictionFactor> factors;
  final DateTime createdAt;

  PredictiveData({
    required this.binId,
    required this.predictionDate,
    required this.predictedFillLevel,
    required this.confidence,
    required this.factors,
    required this.createdAt,
  });

  factory PredictiveData.fromJson(Map<String, dynamic> json) {
    return PredictiveData(
      binId: json['binId'],
      predictionDate: DateTime.parse(json['predictionDate']),
      predictedFillLevel: json['predictedFillLevel'].toDouble(),
      confidence: json['confidence'].toDouble(),
      factors: (json['factors'] as List)
          .map((e) => PredictionFactor.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'binId': binId,
      'predictionDate': predictionDate.toIso8601String(),
      'predictedFillLevel': predictedFillLevel,
      'confidence': confidence,
      'factors': factors.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PredictionFactor {
  final String name;
  final double weight; // 0.0 to 1.0
  final double impact; // positive or negative impact
  final String description;

  PredictionFactor({
    required this.name,
    required this.weight,
    required this.impact,
    required this.description,
  });

  factory PredictionFactor.fromJson(Map<String, dynamic> json) {
    return PredictionFactor(
      name: json['name'],
      weight: json['weight'].toDouble(),
      impact: json['impact'].toDouble(),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'impact': impact,
      'description': description,
    };
  }
}

enum AnalyticsType {
  fillLevel,
  collection,
  route,
  fuel,
  maintenance,
  alert,
  efficiency,
  wasteType,
  zone,
  weather,
  traffic,
}
