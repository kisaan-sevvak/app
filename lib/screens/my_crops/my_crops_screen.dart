import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kisan_sevak/utils/theme.dart';
import 'package:kisan_sevak/widgets/common/custom_button.dart';
import 'package:kisan_sevak/services/navigation_service.dart';
import 'package:kisan_sevak/models/crop_model.dart';
import 'package:kisan_sevak/screens/my_crops/add_edit_crop_screen.dart';

class MyCropsScreen extends StatefulWidget {
  const MyCropsScreen({super.key});

  @override
  State<MyCropsScreen> createState() => _MyCropsScreenState();
}

class _MyCropsScreenState extends State<MyCropsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Crop> _crops = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCrops();
  }

  Future<void> _loadCrops() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final cropsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('crops')
          .get();

      final crops = cropsSnapshot.docs
          .map((doc) => Crop.fromMap(doc.data(), doc.id))
          .toList();

      setState(() {
        _crops = crops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading crops: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _deleteCrop(String cropId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('crops')
          .doc(cropId)
          .delete();

      setState(() {
        _crops.removeWhere((crop) => crop.id == cropId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Crop deleted successfully'.tr()),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting crop: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(String cropId, String cropName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Crop'.tr()),
        content: Text('Are you sure you want to delete $cropName?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteCrop(cropId);
            },
            child: Text(
              'Delete'.tr(),
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Crops'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCrops,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _crops.isEmpty
              ? _buildEmptyState()
              : _buildCropsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => NavigationService.navigateTo('/crop-journey'),
        icon: const Icon(Icons.add),
        label: Text('Add Crop'.tr()),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture,
            size: 80,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Crops Yet'.tr(),
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your farming journey by adding your first crop'.tr(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add Your First Crop'.tr(),
            onPressed: () => NavigationService.navigateTo('/crop-journey'),
            icon: Icons.add,
          ),
        ],
      ),
    );
  }

  Widget _buildCropsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _crops.length,
      itemBuilder: (context, index) {
        final crop = _crops[index];
        return _buildCropCard(crop);
      },
    );
  }

  Widget _buildCropCard(Crop crop) {
    final healthColor = _getHealthColor(crop.healthStatus);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditCropScreen(crop: crop),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.agriculture,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crop.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Planted on ${_formatDate(crop.plantingDate)}'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: healthColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      crop.healthStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(
                    Icons.landscape,
                    '${crop.fieldSize} acres'.tr(),
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    Icons.favorite,
                    crop.healthStatus,
                    color: healthColor,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: crop.progress / 100,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    '${crop.progress}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color ?? AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color ?? AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(String healthStatus) {
    switch (healthStatus.toLowerCase()) {
      case 'excellent':
        return AppTheme.successColor;
      case 'good':
        return AppTheme.primaryColor;
      case 'fair':
        return AppTheme.warningColor;
      case 'poor':
        return AppTheme.errorColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 