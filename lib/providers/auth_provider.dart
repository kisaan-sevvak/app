import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;
  
  User? _user;
  bool _isLoading = true;
  String? _userLocation;
  String? _userName;

  AuthProvider() {
    _init();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get userLocation => _userLocation;
  String? get userName => _userName;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _loadUserData();
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        _userName = userDoc.data()?['name'];
        _userLocation = userDoc.data()?['location'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _prefs.setBool('remember_me', true);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name, String location) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'location': location,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _userName = name;
      _userLocation = location;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _prefs.setBool('remember_me', false);
      _userName = null;
      _userLocation = null;
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    }
  }

  Future<void> updateProfile({String? name, String? location}) async {
    if (_user == null) return;

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (location != null) updates['location'] = location;

      await _firestore.collection('users').doc(_user!.uid).update(updates);

      if (name != null) _userName = name;
      if (location != null) _userLocation = location;
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating profile: $e');
      rethrow;
    }
  }
} 