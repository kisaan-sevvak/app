class Crop {
  final String id;
  final String name;
  final String variety;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final double fieldSize;
  final String fieldUnit;
  final String status;
  final List<String> images;
  final Map<String, dynamic> additionalInfo;
  final DateTime plantingDate;
  final double fieldSize;
  final String healthStatus;
  final int progress;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.fieldSize,
    required this.fieldUnit,
    required this.status,
    required this.images,
    required this.additionalInfo,
    required this.healthStatus,
    required this.progress,
    this.imageUrl,
    this.metadata,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      variety: json['variety'],
      plantingDate: DateTime.parse(json['planting_date']),
      expectedHarvestDate: DateTime.parse(json['expected_harvest_date']),
      fieldSize: json['field_size'].toDouble(),
      fieldUnit: json['field_unit'],
      status: json['status'],
      images: List<String>.from(json['images']),
      additionalInfo: json['additional_info'],
      healthStatus: json['health_status'],
      progress: json['progress'],
      imageUrl: json['image_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'variety': variety,
      'planting_date': plantingDate.toIso8601String(),
      'expected_harvest_date': expectedHarvestDate.toIso8601String(),
      'field_size': fieldSize,
      'field_unit': fieldUnit,
      'status': status,
      'images': images,
      'additional_info': additionalInfo,
      'health_status': healthStatus,
      'progress': progress,
      'image_url': imageUrl,
      'metadata': metadata,
    };
  }

  Crop copyWith({
    String? id,
    String? name,
    String? variety,
    DateTime? plantingDate,
    DateTime? expectedHarvestDate,
    double? fieldSize,
    String? fieldUnit,
    String? status,
    List<String>? images,
    Map<String, dynamic>? additionalInfo,
    String? healthStatus,
    int? progress,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Crop(
      id: id ?? this.id,
      name: name ?? this.name,
      variety: variety ?? this.variety,
      plantingDate: plantingDate ?? this.plantingDate,
      expectedHarvestDate: expectedHarvestDate ?? this.expectedHarvestDate,
      fieldSize: fieldSize ?? this.fieldSize,
      fieldUnit: fieldUnit ?? this.fieldUnit,
      status: status ?? this.status,
      images: images ?? this.images,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      healthStatus: healthStatus ?? this.healthStatus,
      progress: progress ?? this.progress,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}

class CropData {
  final String name;
  final String variety;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final double fieldSize;
  final String fieldUnit;
  final Map<String, dynamic> additionalInfo;

  CropData({
    required this.name,
    required this.variety,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.fieldSize,
    required this.fieldUnit,
    required this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'variety': variety,
      'planting_date': plantingDate.toIso8601String(),
      'expected_harvest_date': expectedHarvestDate.toIso8601String(),
      'field_size': fieldSize,
      'field_unit': fieldUnit,
      'additional_info': additionalInfo,
    };
  }
}

class CropRecommendation {
  final String cropName;
  final String variety;
  final double confidence;
  final String season;
  final Map<String, dynamic> growthConditions;
  final List<String> bestPractices;

  CropRecommendation({
    required this.cropName,
    required this.variety,
    required this.confidence,
    required this.season,
    required this.growthConditions,
    required this.bestPractices,
  });

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      cropName: json['crop_name'],
      variety: json['variety'],
      confidence: json['confidence'].toDouble(),
      season: json['season'],
      growthConditions: json['growth_conditions'],
      bestPractices: List<String>.from(json['best_practices']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop_name': cropName,
      'variety': variety,
      'confidence': confidence,
      'season': season,
      'growth_conditions': growthConditions,
      'best_practices': bestPractices,
    };
  }
}

class CropDisease {
  final String name;
  final String cropName;
  final double confidence;
  final String severity;
  final String description;
  final List<String> symptoms;
  final List<String> treatments;
  final List<String> preventiveMeasures;

  CropDisease({
    required this.name,
    required this.cropName,
    required this.confidence,
    required this.severity,
    required this.description,
    required this.symptoms,
    required this.treatments,
    required this.preventiveMeasures,
  });

  factory CropDisease.fromJson(Map<String, dynamic> json) {
    return CropDisease(
      name: json['name'],
      cropName: json['crop_name'],
      confidence: json['confidence'].toDouble(),
      severity: json['severity'],
      description: json['description'],
      symptoms: List<String>.from(json['symptoms']),
      treatments: List<String>.from(json['treatments']),
      preventiveMeasures: List<String>.from(json['preventive_measures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'crop_name': cropName,
      'confidence': confidence,
      'severity': severity,
      'description': description,
      'symptoms': symptoms,
      'treatments': treatments,
      'preventive_measures': preventiveMeasures,
    };
  }
}

class CropTask {
  final String id;
  final String cropId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;
  final String category;
  final Map<String, dynamic> additionalInfo;

  CropTask({
    required this.id,
    required this.cropId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.category,
    required this.additionalInfo,
  });

  factory CropTask.fromJson(Map<String, dynamic> json) {
    return CropTask(
      id: json['id'],
      cropId: json['crop_id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'],
      category: json['category'],
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_id': cropId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'category': category,
      'additional_info': additionalInfo,
    };
  }
} 