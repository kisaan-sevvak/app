import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kisan_sevak/services/navigation_service.dart';
import 'package:kisan_sevak/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late AnimationController _animationController;
  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Kisan Saathi',
      description: 'Your AI-powered farming assistant that helps you grow better crops and increase your yield',
      icon: Icons.agriculture,
      color: AppTheme.primaryColor,
    ),
    OnboardingPage(
      title: 'Smart Crop Planning',
      description: 'Get AI-powered recommendations for the best crops to grow based on your soil, climate, and market demand',
      icon: Icons.eco,
      color: AppTheme.secondaryColor,
    ),
    OnboardingPage(
      title: 'Disease Detection',
      description: 'Instantly detect crop diseases using your phone\'s camera and get treatment recommendations',
      icon: Icons.camera_alt,
      color: AppTheme.accentColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _pages[_currentPage].color.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: [
                // Language selector
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LanguageSelector(),
                  ),
                ),
                
                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                        _isLastPage = index == _pages.length - 1;
                      });
                    },
                    itemBuilder: (context, index) {
                      return OnboardingPageWidget(
                        page: _pages[index],
                        animationController: _animationController,
                      );
                    },
                  ),
                ),
                
                // Bottom navigation
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Page indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Action button
                      if (_isLastPage)
                        ElevatedButton(
                          onPressed: _completeOnboarding,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          child: Text(
                            'Get Started'.tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ).animate().fadeIn().slideY(begin: 0.3, end: 0)
                      else
                        TextButton(
                          onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          ),
                          child: Text(
                            'Next'.tr(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 32 : 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage].color
            : _pages[_currentPage].color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) {
      NavigationService.navigateTo('/auth');
    }
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final AnimationController animationController;

  const OnboardingPageWidget({
    Key? key,
    required this.page,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (0.1 * animationController.value),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: page.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        page.icon,
                        size: 100,
                        color: page.color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          // Title
          Text(
            page.title,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: page.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (String languageCode) {
        context.setLocale(Locale(languageCode));
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'en',
          child: Text('English'),
        ),
        const PopupMenuItem<String>(
          value: 'hi',
          child: Text('हिंदी'),
        ),
        const PopupMenuItem<String>(
          value: 'mr',
          child: Text('मराठी'),
        ),
        const PopupMenuItem<String>(
          value: 'gu',
          child: Text('ગુજરાતી'),
        ),
        const PopupMenuItem<String>(
          value: 'bn',
          child: Text('বাংলা'),
        ),
        const PopupMenuItem<String>(
          value: 'ta',
          child: Text('தமிழ்'),
        ),
        const PopupMenuItem<String>(
          value: 'te',
          child: Text('తెలుగు'),
        ),
        const PopupMenuItem<String>(
          value: 'kn',
          child: Text('ಕನ್ನಡ'),
        ),
        const PopupMenuItem<String>(
          value: 'ml',
          child: Text('മലയാളം'),
        ),
        const PopupMenuItem<String>(
          value: 'pa',
          child: Text('ਪੰਜਾਬੀ'),
        ),
      ],
    );
  }
} 