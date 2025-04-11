import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import '../models/market_model.dart';
import 'auth_service.dart';

class MarketService {
  final AuthService _authService = AuthService();
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://kisan-saathi-api.railway.app/api',
  );

  // Singleton pattern
  static final MarketService _instance = MarketService._internal();
  factory MarketService() => _instance;
  MarketService._internal();

  // Cache duration in minutes
  static const int _cacheDuration = 60;

  Future<List<MarketPrice>> getMarketPrices({
    required String commodity,
    required String state,
    String? market,
  }) async {
    try {
      // Check cache first
      final cachedData = await _getCachedPrices(commodity, state, market);
      if (cachedData != null) {
        return cachedData;
      }

      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Build query parameters
      final queryParams = {
        'commodity': commodity,
        'state': state,
        if (market != null) 'market': market,
      };

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/market/prices').replace(queryParameters: queryParams),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch market prices');
      }

      final List<dynamic> pricesJson = json.decode(response.body);
      final prices = pricesJson.map((json) => MarketPrice.fromJson(json)).toList();

      // Cache the response
      await _cachePrices(prices, commodity, state, market);

      return prices;
    } catch (e) {
      throw Exception('Error getting market prices: $e');
    }
  }

  Future<List<String>> getAvailableCommodities() async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/market/commodities'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch commodities');
      }

      final List<dynamic> commoditiesJson = json.decode(response.body);
      return List<String>.from(commoditiesJson);
    } catch (e) {
      throw Exception('Error getting commodities: $e');
    }
  }

  Future<List<String>> getAvailableMarkets(String state) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/market/markets').replace(
          queryParameters: {'state': state},
        ),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch markets');
      }

      final List<dynamic> marketsJson = json.decode(response.body);
      return List<String>.from(marketsJson);
    } catch (e) {
      throw Exception('Error getting markets: $e');
    }
  }

  Future<List<MarketPrice>?> _getCachedPrices(
    String commodity,
    String state,
    String? market,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getCacheKey(commodity, state, market);
    final String? cachedData = prefs.getString(key);
    final int? timestamp = prefs.getInt('${key}_timestamp');

    if (cachedData != null && timestamp != null) {
      final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final DateTime now = DateTime.now();
      
      if (now.difference(cacheTime).inMinutes < _cacheDuration) {
        final List<dynamic> pricesJson = json.decode(cachedData);
        return pricesJson.map((json) => MarketPrice.fromJson(json)).toList();
      }
    }
    return null;
  }

  Future<void> _cachePrices(
    List<MarketPrice> prices,
    String commodity,
    String state,
    String? market,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getCacheKey(commodity, state, market);
    await prefs.setString(key, json.encode(prices.map((p) => p.toJson()).toList()));
    await prefs.setInt('${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  String _getCacheKey(String commodity, String state, String? market) {
    return 'market_prices_${commodity}_${state}_${market ?? "all"}';
  }
} 