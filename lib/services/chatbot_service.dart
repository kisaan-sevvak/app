import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';
import '../models/chatbot_model.dart';
import 'auth_service.dart';

class ChatbotService {
  final AuthService _authService = AuthService();
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://kisan-saathi-api.onrender.com/api',
  );

  // Singleton pattern
  static final ChatbotService _instance = ChatbotService._internal();
  factory ChatbotService() => _instance;
  ChatbotService._internal();

  Future<ChatbotResponse> sendMessage(String message) async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/message'),
        headers: headers,
        body: json.encode({
          'message': message,
          'language': 'en', // TODO: Get from localization
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to get chatbot response');
      }

      return ChatbotResponse.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<ChatbotSuggestion>> getSuggestions() async {
    try {
      // Get auth headers
      final headers = await _authService.getAuthHeaders();

      // Make API request
      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/suggestions'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to get suggestions');
      }

      final List<dynamic> suggestionsJson = json.decode(response.body);
      return suggestionsJson.map((json) => ChatbotSuggestion.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error getting suggestions: $e');
    }
  }

  Future<void> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final chatHistory = messages.map((msg) => {
        'text': msg.text,
        'isUser': msg.isUser,
        'timestamp': msg.timestamp.toIso8601String(),
      }).toList();
      
      await prefs.setString('chat_history', json.encode(chatHistory));
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? chatHistoryJson = prefs.getString('chat_history');
      
      if (chatHistoryJson == null) return [];

      final List<dynamic> chatHistory = json.decode(chatHistoryJson);
      return chatHistory.map((msg) => ChatMessage(
        text: msg['text'],
        isUser: msg['isUser'],
        timestamp: DateTime.parse(msg['timestamp']),
      )).toList();
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }
} 