import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  final Function(CameraImage) onCameraImage;

  const CameraWidget({Key? key, required this.onCameraImage}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  String? _errorMessage;
  double widgetWidth = 0.0;
  double widgetHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initializeCamera();
    } else if (state == AppLifecycleState.paused) {
      _controller?.dispose();
    }
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.ultraHigh);
        _initializeControllerFuture = _controller!.initialize();
        await _initializeControllerFuture;
        if (mounted) {
          setState(() {
            widgetWidth = _controller!.value.previewSize!.width;
            widgetHeight = _controller!.value.previewSize!.height;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'No available cameras';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error initializing camera: $e';
      });
    }
  }

  void onCameraImage(CameraImage cameraImage) {
    widget.onCameraImage(cameraImage);
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(); // Return an empty container or a loading indicator
    }

    final size = MediaQuery.of(context).size;

    return Center(
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller!.startImageStream((CameraImage cameraImage) {
              onCameraImage(cameraImage);
            });

            return SizedBox(
              width: size.width *
                  1, // Adjust the width as desired (e.g., 80% of the screen width)
              height: size.height *
                  1, // Adjust the height as desired (e.g., 60% of the screen height)
              child: CameraPreview(_controller!),
              // child: ObjectDetectionWidget(
              //   cameraImage: _controller!.value.isStreamingImages
              //       ? _controller!.value.image
              //       : null,
              // ),
            );
          } else {
            return Container(); // Return a loading indicator
          }
        },
      ),
    );
  }
}
