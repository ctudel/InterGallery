import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hw5/models/main_scaffold.dart';
import 'package:hw5/pages/homepage.dart';
import '../pages/photo_edit_page.dart';
import '../pages/camera.dart';
import '../models/photo.dart';

late final List<CameraDescription> _cameras;

Future<void> init() async {
  _cameras = await availableCameras();
}

final routes = {
  '/': (context) => homePage,
  '/camera': (context) => Camera(camera: _cameras[0]),
  // '/edit-photo': (context) => editPhotoPage,
};

// ===========================
// Pages with default scaffold
// ===========================
const MainScaffold homePage = MainScaffold(title: 'Home', child: HomePage());

// final MainScaffold editPhotoPage =
//     MainScaffold(child: PhotoEdit(imagePath: ''), title: 'Photo Editor');

photoEditPage(settings) {
  if (settings.name == '/edit-photo') {
    final args = settings.arguments as Photo;

    return MaterialPageRoute(builder: (context) {
      return MainScaffold(
          title: 'Photo Editor',
          child: PhotoEdit(
            imagePath: args.path,
          ));
    });
  }
}
