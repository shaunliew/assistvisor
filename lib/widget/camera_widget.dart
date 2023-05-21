import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  @override
  void dispose() async {
    await _initializeControllerFuture;
    await _controller.dispose();
    super.dispose();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
      _initializeControllerFuture = _controller.initialize();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container(); // Return an empty container or a loading indicator
    }

    return Center(
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final size = MediaQuery.of(context).size;
            return SizedBox(
              width: size.width, // Adjust the width as desired
              height: size.height, // Adjust the height as desired
              child: CameraPreview(_controller),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
