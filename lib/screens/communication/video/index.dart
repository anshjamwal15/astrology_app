import 'package:astrology_app/constants/index.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front),
        ResolutionPreset.high,
      );

      await _cameraController.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstants.bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isCameraInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    // width: _cameraController.value.previewSize!.width,
                    height: _cameraController.value.previewSize!.height,
                    child: CameraPreview(_cameraController),
                  ),
                ),
              )
            else
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            // Back button
            Positioned(
              top: 16.0,
              left: 16.0,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
              ),
            ),
            // Other user's video
            Positioned(
              top: 64.0,
              right: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/astologer.jpg',
                    fit: BoxFit.cover,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ),
            // Control buttons
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.mic_off,
                          size: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.volume_up_sharp,
                          size: 24, color: Colors.black),
                    ),
                  ),
                  SizedBox(width: size.width * 0.06),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 0.2),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call_end,
                          size: 24, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
