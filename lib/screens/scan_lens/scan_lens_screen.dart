import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class ScanLensScreen extends StatefulWidget {
  const ScanLensScreen({super.key});

  @override
  State<ScanLensScreen> createState() => _ScanLensScreenState();
}

class _ScanLensScreenState extends State<ScanLensScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isScanning = false;
  String? _scanResult;
  String? _scanImagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agro Lens'.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isCameraInitialized
                ? _buildCameraPreview()
                : const Center(child: CircularProgressIndicator()),
          ),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        CameraPreview(_controller!),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCameraButton(
                icon: Icons.flip_camera_ios,
                onPressed: _switchCamera,
              ),
              _buildCameraButton(
                icon: Icons.camera_alt,
                onPressed: _captureImage,
              ),
              _buildCameraButton(
                icon: Icons.flash_on,
                onPressed: _toggleFlash,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPanel() {
    if (_isScanning) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_scanResult != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scan Result'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _scanResult!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveScanResult,
                  icon: const Icon(Icons.save),
                  label: Text('Save'.tr()),
                ),
                ElevatedButton.icon(
                  onPressed: _resetScan,
                  icon: const Icon(Icons.refresh),
                  label: Text('Scan Again'.tr()),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Point camera at crop leaf or soil'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'For best results, ensure good lighting and focus'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }

  Future<void> _switchCamera() async {
    if (_controller == null) return;

    final cameras = await availableCameras();
    if (cameras.length < 2) return;

    final newCameraIndex = _controller!.description.lensDirection == CameraLensDirection.back
        ? 0
        : 1;

    await _controller!.dispose();
    _controller = CameraController(
      cameras[newCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      final mode = _controller!.value.flashMode;
      if (mode == FlashMode.off) {
        await _controller!.setFlashMode(FlashMode.torch);
      } else {
        await _controller!.setFlashMode(FlashMode.off);
      }
      setState(() {});
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    setState(() => _isScanning = true);

    try {
      final image = await _controller!.takePicture();
      _scanImagePath = image.path;
      
      // Simulate AI analysis (replace with actual ML model)
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _scanResult = 'Disease Detected: Leaf Blight\nRisk Level: Medium\nRecommended Treatment: Apply fungicide spray';
        _isScanning = false;
      });
    } catch (e) {
      setState(() => _isScanning = false);
      _showError('Error capturing image'.tr());
    }
  }

  Future<void> _saveScanResult() async {
    if (_scanImagePath == null || _scanResult == null) return;

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('scans')
          .child(userId)
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(File(_scanImagePath!));
      final imageUrl = await storageRef.getDownloadURL();

      // Save scan result to Firestore
      await FirebaseFirestore.instance.collection('scans').add({
        'userId': userId,
        'imageUrl': imageUrl,
        'result': _scanResult,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Scan result saved'.tr())),
        );
      }
    } catch (e) {
      _showError('Error saving scan result'.tr());
    }
  }

  void _resetScan() {
    setState(() {
      _scanResult = null;
      _scanImagePath = null;
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
} 