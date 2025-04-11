class WeatherData {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime timestamp;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.timestamp,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['temperature'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      humidity: json['humidity'],
      windSpeed: json['wind_speed'].toDouble(),
      description: json['description'],
      icon: json['icon'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feels_like': feelsLike,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'description': description,
      'icon': icon,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final double rainProbability;

  WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.rainProbability,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date']),
      maxTemp: json['max_temp'].toDouble(),
      minTemp: json['min_temp'].toDouble(),
      humidity: json['humidity'],
      windSpeed: json['wind_speed'].toDouble(),
      description: json['description'],
      icon: json['icon'],
      rainProbability: json['rain_probability'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'max_temp': maxTemp,
      'min_temp': minTemp,
      'humidity': humidity,
      'wind_speed': windSpeed,
      'description': description,
      'icon': icon,
      'rain_probability': rainProbability,
    };
  }
}

class WeatherAlert {
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String severity;
  final String type;

  WeatherAlert({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.severity,
    required this.type,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      severity: json['severity'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'severity': severity,
      'type': type,
    };
  }
} 