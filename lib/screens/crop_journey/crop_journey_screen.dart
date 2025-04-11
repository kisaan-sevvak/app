import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CropJourneyScreen extends StatefulWidget {
  const CropJourneyScreen({super.key});

  @override
  State<CropJourneyScreen> createState() => _CropJourneyScreenState();
}

class _CropJourneyScreenState extends State<CropJourneyScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _cropData = {};

  final List<JourneyStep> _steps = [
    JourneyStep(
      title: 'Select Crop',
      description: 'Choose a crop to grow',
      icon: Icons.agriculture,
    ),
    JourneyStep(
      title: 'Field Selection',
      description: 'Select or scan your field',
      icon: Icons.map,
    ),
    JourneyStep(
      title: 'Soil Analysis',
      description: 'Analyze soil type and health',
      icon: Icons.science,
    ),
    JourneyStep(
      title: 'Seed Selection',
      description: 'Choose the right seeds',
      icon: Icons.grass,
    ),
    JourneyStep(
      title: 'Sowing Plan',
      description: 'Plan your sowing schedule',
      icon: Icons.calendar_today,
    ),
    JourneyStep(
      title: 'Irrigation Plan',
      description: 'Plan your irrigation schedule',
      icon: Icons.water_drop,
    ),
    JourneyStep(
      title: 'Fertilizer Plan',
      description: 'Plan your fertilizer schedule',
      icon: Icons.eco,
    ),
    JourneyStep(
      title: 'Review',
      description: 'Review and start farming',
      icon: Icons.check_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Farming'.tr()),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < _steps.length - 1) {
            setState(() {
              _currentStep++;
            });
          } else {
            _saveCropJourney();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },
        steps: _steps.map((step) {
          return Step(
            title: Text(step.title.tr()),
            content: _buildStepContent(step),
            isActive: _currentStep >= _steps.indexOf(step),
            state: _currentStep > _steps.indexOf(step)
                ? StepState.complete
                : StepState.indexed,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStepContent(JourneyStep step) {
    switch (step.title) {
      case 'Select Crop':
        return _buildCropSelection();
      case 'Field Selection':
        return _buildFieldSelection();
      case 'Soil Analysis':
        return _buildSoilAnalysis();
      case 'Seed Selection':
        return _buildSeedSelection();
      case 'Sowing Plan':
        return _buildSowingPlan();
      case 'Irrigation Plan':
        return _buildIrrigationPlan();
      case 'Fertilizer Plan':
        return _buildFertilizerPlan();
      case 'Review':
        return _buildReview();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCropSelection() {
    return Column(
      children: [
        Text(
          'AI Recommended Crops'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildCropCard(
          'Wheat',
          'Best suited for your soil type',
          'assets/images/wheat.jpg',
          () => _selectCrop('Wheat'),
        ),
        _buildCropCard(
          'Rice',
          'Good for monsoon season',
          'assets/images/rice.jpg',
          () => _selectCrop('Rice'),
        ),
        _buildCropCard(
          'Cotton',
          'High market demand',
          'assets/images/cotton.jpg',
          () => _selectCrop('Cotton'),
        ),
      ],
    );
  }

  Widget _buildFieldSelection() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Open map for field selection
          },
          icon: const Icon(Icons.map),
          label: Text('Select on Map'.tr()),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Open camera for field scanning
          },
          icon: const Icon(Icons.camera_alt),
          label: Text('Scan Field'.tr()),
        ),
      ],
    );
  }

  Widget _buildSoilAnalysis() {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            // TODO: Open camera for soil scanning
          },
          icon: const Icon(Icons.camera_alt),
          label: Text('Scan Soil'.tr()),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Soil Type'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: [
                    'Clay'.tr(),
                    'Sandy'.tr(),
                    'Loamy'.tr(),
                    'Silt'.tr(),
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _cropData['soilType'] = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeedSelection() {
    return Column(
      children: [
        Text(
          'Recommended Seeds'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildSeedCard(
          'High Yield Variety',
          'Best for your soil type',
          '₹450/kg',
          () => _selectSeed('High Yield'),
        ),
        _buildSeedCard(
          'Disease Resistant',
          'Good for your region',
          '₹500/kg',
          () => _selectSeed('Disease Resistant'),
        ),
      ],
    );
  }

  Widget _buildSowingPlan() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Sowing Period'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('October 15 - November 15'),
                const SizedBox(height: 16),
                Text(
                  'Recommended Practices'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('• Prepare soil 2 weeks before sowing'),
                Text('• Maintain proper spacing'),
                Text('• Use recommended seed rate'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIrrigationPlan() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Irrigation Schedule'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('• Initial irrigation: After sowing'),
                Text('• Regular intervals: Every 7-10 days'),
                Text('• Critical stages: Flowering and grain filling'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFertilizerPlan() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fertilizer Schedule'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text('• Basal: NPK 10:26:26'),
                Text('• Top dressing: Urea'),
                Text('• Timing: 25 and 45 days after sowing'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReview() {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crop Summary'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildSummaryItem('Crop', _cropData['crop'] ?? 'Not selected'),
                _buildSummaryItem('Soil Type', _cropData['soilType'] ?? 'Not selected'),
                _buildSummaryItem('Seed Type', _cropData['seedType'] ?? 'Not selected'),
                _buildSummaryItem('Sowing Period', 'October 15 - November 15'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _saveCropJourney,
          child: Text('Start Farming'.tr()),
        ),
      ],
    );
  }

  Widget _buildCropCard(String name, String description, String image, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: const Icon(Icons.image, size: 40),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeedCard(String name, String description, String price, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  void _selectCrop(String crop) {
    setState(() {
      _cropData['crop'] = crop;
    });
  }

  void _selectSeed(String seedType) {
    setState(() {
      _cropData['seedType'] = seedType;
    });
  }

  Future<void> _saveCropJourney() async {
    try {
      await FirebaseFirestore.instance.collection('crops').add({
        ..._cropData,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving crop journey'.tr()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class JourneyStep {
  final String title;
  final String description;
  final IconData icon;

  JourneyStep({
    required this.title,
    required this.description,
    required this.icon,
  });
} 