import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yaml/yaml.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with WidgetsBindingObserver {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
    //loadModel();
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

  Future<void> loadModel() async {
    try {
      String modelPath = 'assets/best_saved_model/best_float32.tflite';
      String labelsPath = 'assets/best_saved_model/metadata.yaml';

      final interpreterOptions = InterpreterOptions()
        ..useNnApiForAndroid = true;

      Interpreter interpreter =
          await Interpreter.fromAsset(modelPath, options: interpreterOptions);

      String labelsData = await rootBundle.loadString(labelsPath);
      Map<String, dynamic> labelsMap = loadYaml(labelsData);
      List<String> labels = labelsMap['names'].values.cast<String>().toList();

      // Perform additional setup or initialization if needed
    } catch (e) {
      print('Failed to load the model: $e');
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
          setState(() {});
        }
      } else {
        print('No available cameras');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container(); // Return an empty container or a loading indicator
    }

    final size = MediaQuery.of(context).size;

    return Center(
      child: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox(
              width: size.width *
                  1, // Adjust the width as desired (e.g., 80% of the screen width)
              height: size.height *
                  1, // Adjust the height as desired (e.g., 60% of the screen height)
              child: CameraPreview(_controller!),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
