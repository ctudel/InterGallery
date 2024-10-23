import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './photo_edit_page.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Diplay Picture'),
      ),
      body: FutureBuilder<void>(
          future: _cameraReady,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            _controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(_controller));
          }),
      // Take picture button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Verify camera is initialized
            await _cameraReady;
            final image = await _controller.takePicture();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PhotoEdit(imagePath: image.path)));
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
