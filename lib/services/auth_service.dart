import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '21211664594-uhv4iij3df3gabn0lq2nrlagnl112co4.apps.googleusercontent.com',
  );

  // Store the base URL for the API
  final String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://kisan-saathi-api.railway.app/api',
  );

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Sign in aborted');

      // Get auth details from request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Send token to backend
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': googleAuth.idToken,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to authenticate with server');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      
      // Store the JWT token
      await _saveToken(data['token']);

      return {
        'success': true,
        'user': {
          'email': googleUser.email,
          'name': googleUser.displayName,
          'photoUrl': googleUser.photoUrl,
        }
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _clearToken();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<bool> isSignedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // Token management
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get auth headers for API requests
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _getToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
} 