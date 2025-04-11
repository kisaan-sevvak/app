import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import '../models/crop_model.dart';
import 'auth_service.dart';

class CropService {
  final AuthService _authService = AuthService();
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://kisan-saathi-api.railway.app/api',
  );

  // Singleton pattern
  static final CropService _instance = CropService._internal();
  factory CropService() => _instance;
  CropService._internal();

  Future<List<Crop>> getMyCrops() async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/crops/my'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch crops');
      }

      final List<dynamic> cropsJson = json.decode(response.body);
      return cropsJson.map((json) => Crop.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting crops: $e');
    }
  }

  Future<Crop> addCrop(CropData cropData) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.post(
        Uri.parse('$baseUrl/crops'),
        headers: headers,
        body: json.encode(cropData.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        throw Exception('Failed to add crop');
      }

      return Crop.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error adding crop: $e');
    }
  }

  Future<void> updateCrop(String cropId, CropData cropData) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.put(
        Uri.parse('$baseUrl/crops/$cropId'),
        headers: headers,
        body: json.encode(cropData.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update crop');
      }
    } catch (e) {
      throw Exception('Error updating crop: $e');
    }
  }

  Future<void> deleteCrop(String cropId) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.delete(
        Uri.parse('$baseUrl/crops/$cropId'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete crop');
      }
    } catch (e) {
      throw Exception('Error deleting crop: $e');
    }
  }

  Future<List<CropRecommendation>> getCropRecommendations({
    required double latitude,
    required double longitude,
    required String soilType,
  }) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Build query parameters
      final queryParams = {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'soil_type': soilType,
      };

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/crops/recommendations').replace(queryParameters: queryParams),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch crop recommendations');
      }

      final List<dynamic> recommendationsJson = json.decode(response.body);
      return recommendationsJson.map((json) => CropRecommendation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting crop recommendations: $e');
    }
  }

  Future<List<CropDisease>> detectDiseases(String imageBase64) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.post(
        Uri.parse('$baseUrl/crops/diseases/detect'),
        headers: headers,
        body: json.encode({'image': imageBase64}),
      ).timeout(const Duration(seconds: 30)); // Longer timeout for image processing

      if (response.statusCode != 200) {
        throw Exception('Failed to detect diseases');
      }

      final List<dynamic> diseasesJson = json.decode(response.body);
      return diseasesJson.map((json) => CropDisease.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error detecting diseases: $e');
    }
  }

  Future<List<CropTask>> getCropTasks(String cropId) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/crops/$cropId/tasks'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch crop tasks');
      }

      final List<dynamic> tasksJson = json.decode(response.body);
      return tasksJson.map((json) => CropTask.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting crop tasks: $e');
    }
  }

  Future<void> updateTaskStatus(String cropId, String taskId, String status) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.put(
        Uri.parse('$baseUrl/crops/$cropId/tasks/$taskId'),
        headers: headers,
        body: json.encode({'status': status}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update task status');
      }
    } catch (e) {
      throw Exception('Error updating task status: $e');
    }
  }
} 