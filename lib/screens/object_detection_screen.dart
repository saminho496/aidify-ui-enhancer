
import 'package:flutter/material.dart';
import 'package:aidify/theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> {
  bool isDetecting = false;
  List<String> detectedObjects = [];
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  bool isCameraInitialized = false;
  bool isFlashOn = false;
  
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
  
  void toggleFlash() async {
    if (cameraController == null) return;
    
    try {
      if (isFlashOn) {
        await cameraController!.setFlashMode(FlashMode.off);
      } else {
        await cameraController!.setFlashMode(FlashMode.torch);
      }
      
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }
  
  void startObjectDetection() async {
    if (isDetecting) return;
    
    setState(() {
      isDetecting = true;
      detectedObjects = [];
    });
    
    // Simulate object detection
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      detectedObjects = [
        'Chair - 92%',
        'Table - 87%',
        'Laptop - 95%',
        'Person - 99%',
        'Plant - 78%',
      ];
      isDetecting = false;
    });
    
    // Play a sound to indicate detection complete
    // In a real app, we'd use something like AudioCache
  }
  
  @override
  void dispose() {
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
        title: const Text('Object Detection'),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: isCameraInitialized ? toggleFlash : null,
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
            
            // Detected objects
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
                      'Detected Objects',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    if (isDetecting)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Detecting objects...'),
                          ],
                        ),
                      )
                    else if (detectedObjects.isEmpty)
                      Center(
                        child: Text(
                          'Point the camera at objects to detect them',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: detectedObjects.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentCoral.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.visibility,
                                  color: AppTheme.accentCoral,
                                ),
                              ),
                              title: Text(detectedObjects[index]),
                              dense: true,
                            );
                          },
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
                  icon: const Icon(Icons.camera_alt),
                  label: Text(isDetecting ? 'Detecting...' : 'Detect Objects'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentCoral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: isDetecting ? null : startObjectDetection,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
