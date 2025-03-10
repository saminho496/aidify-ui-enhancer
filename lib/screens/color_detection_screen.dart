
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class ColorDetectionScreen extends StatefulWidget {
  const ColorDetectionScreen({Key? key}) : super(key: key);

  @override
  _ColorDetectionScreenState createState() => _ColorDetectionScreenState();
}

class _ColorDetectionScreenState extends State<ColorDetectionScreen> {
  bool isDetecting = false;
  String detectedColor = '';
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  bool isTorchOn = false;
  Timer? colorUpdateTimer;
  Color displayColor = Colors.white;
  
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }
  
  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        
        await cameraController!.initialize();
        
        if (mounted) {
          setState(() {
            isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }
  
  void toggleTorch() async {
    if (cameraController == null) return;
    
    try {
      if (isTorchOn) {
        await cameraController!.setFlashMode(FlashMode.off);
      } else {
        await cameraController!.setFlashMode(FlashMode.torch);
      }
      
      setState(() {
        isTorchOn = !isTorchOn;
      });
    } catch (e) {
      print('Error toggling torch: $e');
    }
  }
  
  void startColorDetection() {
    if (isDetecting) {
      // Stop detection
      colorUpdateTimer?.cancel();
      setState(() {
        isDetecting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Color detection stopped')),
      );
    } else {
      // Start detection
      setState(() {
        isDetecting = true;
        detectedColor = 'Detecting...';
      });
      
      // Simulate color detection with random colors
      colorUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        
        // In a real app, this would analyze the camera feed
        // Here we just generate random colors for demonstration
        final colors = [
          {'name': 'Red', 'color': Colors.red},
          {'name': 'Green', 'color': Colors.green},
          {'name': 'Blue', 'color': Colors.blue},
          {'name': 'Yellow', 'color': Colors.yellow},
          {'name': 'Purple', 'color': Colors.purple},
          {'name': 'Orange', 'color': Colors.orange},
          {'name': 'Pink', 'color': Colors.pink},
          {'name': 'Brown', 'color': Colors.brown},
          {'name': 'Grey', 'color': Colors.grey},
          {'name': 'Black', 'color': Colors.black},
          {'name': 'White', 'color': Colors.white},
        ];
        
        final randomIndex = DateTime.now().millisecondsSinceEpoch % colors.length;
        final selectedColor = colors[randomIndex];
        
        setState(() {
          detectedColor = selectedColor['name'] as String;
          displayColor = selectedColor['color'] as Color;
        });
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Color detection started')),
      );
    }
  }
  
  @override
  void dispose() {
    colorUpdateTimer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Color Detection'),
        actions: [
          IconButton(
            icon: Icon(isTorchOn ? Icons.flash_on : Icons.flash_off),
            onPressed: isCameraInitialized ? toggleTorch : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Camera preview
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: isCameraInitialized
                      ? CameraPreview(cameraController!)
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
            ),
            
            // Color information
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detected Color',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    if (!isDetecting && detectedColor.isEmpty)
                      Center(
                        child: Text(
                          'Point the camera at a color to detect it',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    else
                      Expanded(
                        child: Row(
                          children: [
                            // Color preview
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: displayColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            
                            // Color information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    detectedColor,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  // In a real app, we would show RGB values, hex code, etc.
                                  Text(
                                    'RGB: 255, 0, 0',
                                    style: TextStyle(color: AppTheme.textSecondary),
                                  ),
                                  Text(
                                    'HEX: #FF0000',
                                    style: TextStyle(color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(isDetecting ? Icons.stop : Icons.colorize),
                  label: Text(isDetecting ? 'Stop Detection' : 'Start Detection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDetecting ? Colors.red : AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: startColorDetection,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
