import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'auth_service.dart';

class WeatherService {
  final AuthService _authService = AuthService();
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://kisan-saathi-api.railway.app/api',
  );

  // Singleton pattern
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  // Cache duration in minutes
  static const int _cacheDuration = 30;

  Future<WeatherData> getCurrentWeather() async {
    try {
      // Check cache first
      final cachedData = await _getCachedWeather();
      if (cachedData != null) {
        return cachedData;
      }

      // Get current location
      final position = await _getCurrentLocation();
      
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/weather/current?lat=${position.latitude}&lon=${position.longitude}'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch weather data');
      }

      final weatherData = WeatherData.fromJson(json.decode(response.body));
      
      // Cache the response
      await _cacheWeather(weatherData);

      return weatherData;
    } catch (e) {
      throw Exception('Error getting weather: $e');
    }
  }

  Future<List<WeatherForecast>> getWeatherForecast() async {
    try {
      // Get current location
      final position = await _getCurrentLocation();
      
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/weather/forecast?lat=${position.latitude}&lon=${position.longitude}'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch weather forecast');
      }

      final List<dynamic> forecastJson = json.decode(response.body);
      return forecastJson.map((json) => WeatherForecast.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting weather forecast: $e');
    }
  }

  Future<List<WeatherAlert>> getWeatherAlerts() async {
    try {
      // Get current location
      final position = await _getCurrentLocation();
      
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/weather/alerts?lat=${position.latitude}&lon=${position.longitude}'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch weather alerts');
      }

      final List<dynamic> alertsJson = json.decode(response.body);
      return alertsJson.map((json) => WeatherAlert.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting weather alerts: $e');
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherData?> _getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedData = prefs.getString('weather_cache');
    final int? timestamp = prefs.getInt('weather_cache_timestamp');

    if (cachedData != null && timestamp != null) {
      final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final DateTime now = DateTime.now();
      
      if (now.difference(cacheTime).inMinutes < _cacheDuration) {
        return WeatherData.fromJson(json.decode(cachedData));
      }
    }
    return null;
  }

  Future<void> _cacheWeather(WeatherData weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weather_cache', json.encode(weather.toJson()));
    await prefs.setInt('weather_cache_timestamp', DateTime.now().millisecondsSinceEpoch);
  }
} 