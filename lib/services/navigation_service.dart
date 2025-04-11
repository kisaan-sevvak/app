import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final isLoggedIn = prefs.getBool('remember_me') ?? false;
    
    if (!hasSeenOnboarding) {
      return '/onboarding';
    }
    return isLoggedIn ? '/dashboard' : '/auth';
  }

  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static void navigateToReplacement(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  static void navigateToAndRemoveUntil(String routeName) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  static void pop() {
    navigatorKey.currentState?.pop();
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  static Future<T?> navigateToWithData<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }
} 