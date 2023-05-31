import 'package:flutter/material.dart';
import 'dart:async';
import 'widget/object_detection_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 2), () async {
      //send user to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const YoloVideo()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(size: 150),
              SizedBox(height: 10),
              //wrap the text in middle
              Text(
                'Assistvisor - let the visually impaired see',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 20, 20, 98),
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  //wrap the text in middle
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
