import 'package:flutter/material.dart';
import 'widget/camera_widget.dart';
import 'package:camera/camera.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void handleCameraImage(CameraImage cameraImage) {
    // Process the camera image or pass it to the object detection function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Assistvisor',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: CameraWidget(onCameraImage: handleCameraImage),
      ),
    );
  }
}
