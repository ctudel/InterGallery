import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;

  const Camera({super.key, required this.camera});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _cameraReady;

  Future<void> _initCamera() async {
    _controller = CameraController(widget.camera, ResolutionPreset.low);
    _cameraReady = _controller.initialize();
    return _cameraReady;
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _cameraReady,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          return Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: [
              CameraPreview(_controller),
            ],
          );
        });
  }
}
