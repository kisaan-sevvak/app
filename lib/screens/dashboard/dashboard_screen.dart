import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:kisan_sevak/services/navigation_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _location = 'Loading...';
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      // TODO: Use geocoding to get city name
      setState(() {
        _location = 'Your Location';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _location = 'Location not available';
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        NavigationService.navigateTo('/crop-journey');
        break;
      case 2:
        NavigationService.navigateTo('/scan-lens');
        break;
      case 3:
        // TODO: Navigate to profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildSummaryCards(),
              const SizedBox(height: 24),
              _buildRecentActivities(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard),
            label: 'Dashboard'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.agriculture),
            label: 'My Crops'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.camera_alt),
            label: 'Agro Lens'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: 'Profile'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, Farmer!'.tr(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _location,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    // TODO: Show notifications
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildActionCard(
              context,
              'Start Farming'.tr(),
              Icons.agriculture,
              Colors.green,
              () => NavigationService.navigateTo('/crop-journey'),
            ),
            _buildActionCard(
              context,
              'Scan Crop'.tr(),
              Icons.camera_alt,
              Colors.blue,
              () => NavigationService.navigateTo('/scan-lens'),
            ),
            _buildActionCard(
              context,
              'Ask AI'.tr(),
              Icons.chat,
              Colors.purple,
              () {
                // TODO: Navigate to AI chat
              },
            ),
            _buildActionCard(
              context,
              'My Tasks'.tr(),
              Icons.task,
              Colors.orange,
              () {
                // TODO: Navigate to tasks
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildSummaryCard(
                context,
                'Active Crops'.tr(),
                '5',
                Icons.agriculture,
                Colors.green,
              ),
              _buildSummaryCard(
                context,
                'Weather'.tr(),
                '28°C',
                Icons.wb_sunny,
                Colors.orange,
              ),
              _buildSummaryCard(
                context,
                'Soil Status'.tr(),
                'Good',
                Icons.landscape,
                Colors.brown,
              ),
              _buildSummaryCard(
                context,
                'Tasks Due'.tr(),
                '3',
                Icons.task,
                Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildActivityItem(
                'Wheat harvesting completed'.tr(),
                '2 hours ago'.tr(),
              ),
              _buildActivityItem(
                'New weather alert'.tr(),
                '5 hours ago'.tr(),
              ),
              _buildActivityItem(
                'Market price updated'.tr(),
                '1 day ago'.tr(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 8),
      title: Text(title),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }
} 