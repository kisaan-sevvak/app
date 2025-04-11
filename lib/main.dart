import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisan_sevak/screens/onboarding/onboarding_screen.dart';
import 'package:kisan_sevak/screens/auth/auth_screen.dart';
import 'package:kisan_sevak/screens/dashboard/dashboard_screen.dart';
import 'package:kisan_sevak/screens/crop_journey/crop_journey_screen.dart';
import 'package:kisan_sevak/screens/scan_lens/scan_lens_screen.dart';
import 'package:kisan_sevak/screens/my_crops/my_crops_screen.dart';
import 'package:kisan_sevak/screens/gov_schemes/gov_schemes_screen.dart';
import 'package:kisan_sevak/screens/weather/weather_screen.dart';
import 'package:kisan_sevak/screens/mandi_prices/mandi_prices_screen.dart';
import 'package:kisan_sevak/screens/ai_bot/ai_bot_screen.dart';
import 'package:kisan_sevak/screens/settings/settings_screen.dart';
import 'package:kisan_sevak/services/navigation_service.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('gu'),
        Locale('bn'),
        Locale('ta'),
        Locale('te'),
        Locale('kn'),
        Locale('ml'),
        Locale('pa'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Kisan Sevak',
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/':
                  return MaterialPageRoute(
                    builder: (_) => const AuthWrapper(),
                  );
                case '/onboarding':
                  return MaterialPageRoute(
                    builder: (_) => const OnboardingScreen(),
                  );
                case '/auth':
                  return MaterialPageRoute(
                    builder: (_) => const AuthScreen(),
                  );
                case '/dashboard':
                  return MaterialPageRoute(
                    builder: (_) => const DashboardScreen(),
                  );
                case '/crop-journey':
                  return MaterialPageRoute(
                    builder: (_) => const CropJourneyScreen(),
                  );
                case '/scan-lens':
                  return MaterialPageRoute(
                    builder: (_) => const ScanLensScreen(),
                  );
                case '/my-crops':
                  return MaterialPageRoute(
                    builder: (_) => const MyCropsScreen(),
                  );
                case '/gov-schemes':
                  return MaterialPageRoute(
                    builder: (_) => const GovSchemesScreen(),
                  );
                case '/weather':
                  return MaterialPageRoute(
                    builder: (_) => const WeatherScreen(),
                  );
                case '/mandi-prices':
                  return MaterialPageRoute(
                    builder: (_) => const MandiPricesScreen(),
                  );
                case '/ai-bot':
                  return MaterialPageRoute(
                    builder: (_) => const AiBotScreen(),
                  );
                case '/settings':
                  return MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  );
                default:
                  return MaterialPageRoute(
                    builder: (_) => const Scaffold(
                      body: Center(
                        child: Text('Route not found'),
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return authProvider.isAuthenticated
            ? const DashboardScreen()
            : const OnboardingScreen();
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kisan Sevak Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Farmer!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Here\'s your farming dashboard',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStatCard(
                  context,
                  'Crops',
                  '5 Active',
                  Icons.agriculture,
                  Colors.green,
                ),
                _buildStatCard(
                  context,
                  'Weather',
                  '28°C',
                  Icons.wb_sunny,
                  Colors.orange,
                ),
                _buildStatCard(
                  context,
                  'Tasks',
                  '3 Pending',
                  Icons.task,
                  Colors.blue,
                ),
                _buildStatCard(
                  context,
                  'Market',
                  '₹45/kg',
                  Icons.store,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Recent Activities
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activities',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      'Wheat harvesting completed',
                      '2 hours ago',
                    ),
                    _buildActivityItem(
                      'New weather alert',
                      '5 hours ago',
                    ),
                    _buildActivityItem(
                      'Market price updated',
                      '1 day ago',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture),
            label: 'Crops',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
