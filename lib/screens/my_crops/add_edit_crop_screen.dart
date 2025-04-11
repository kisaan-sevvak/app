import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kisan_sevak/models/crop_model.dart';
import 'package:kisan_sevak/widgets/common/custom_text_field.dart';
import 'package:kisan_sevak/utils/theme.dart';

class AddEditCropScreen extends StatefulWidget {
  final Crop? crop;

  const AddEditCropScreen({Key? key, this.crop}) : super(key: key);

  @override
  State<AddEditCropScreen> createState() => _AddEditCropScreenState();
}

class _AddEditCropScreenState extends State<AddEditCropScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fieldSizeController = TextEditingController();
  DateTime _plantingDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.crop != null) {
      _nameController.text = widget.crop!.name;
      _fieldSizeController.text = widget.crop!.fieldSize.toString();
      _plantingDate = widget.crop!.plantingDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fieldSizeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _plantingDate) {
      setState(() {
        _plantingDate = picked;
      });
    }
  }

  Future<void> _saveCrop() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception('User not logged in');

      final cropData = {
        'name': _nameController.text,
        'plantingDate': Timestamp.fromDate(_plantingDate),
        'fieldSize': double.parse(_fieldSizeController.text),
        'healthStatus': 'Good',
        'progress': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (widget.crop == null) {
        // Add new crop
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('crops')
            .add(cropData);
      } else {
        // Update existing crop
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('crops')
            .doc(widget.crop!.id)
            .update(cropData);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop == null ? 'Add New Crop' : 'Edit Crop'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              controller: _nameController,
              labelText: 'Crop Name',
              prefixIcon: Icons.agriculture,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter crop name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _fieldSizeController,
              labelText: 'Field Size (in acres)',
              prefixIcon: Icons.area_chart,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter field size';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Planting Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '${_plantingDate.day}/${_plantingDate.month}/${_plantingDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveCrop,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(widget.crop == null ? 'Add Crop' : 'Update Crop'),
            ),
          ],
        ),
      ),
    );
  }
} 