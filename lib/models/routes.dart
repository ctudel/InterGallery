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
  '/list': (context) => listPage,
  '/grid': (context) => gridPage,
  '/camera': (context) => cameraPage,
};

// ===========================
// Pages with default scaffold
// ===========================
const MainScaffold homePage = MainScaffold(
  child: HomePage(
    viewType: 'home',
  ),
);

const MainScaffold listPage = MainScaffold(
  child: HomePage(
    viewType: 'list',
  ),
);

const MainScaffold gridPage = MainScaffold(
  child: HomePage(
    viewType: 'grid',
  ),
);

final MainScaffold cameraPage = MainScaffold(
  hasActionButton: false,
  child: Camera(camera: _cameras[0]),
);

// Route with parameters passed in
MaterialPageRoute photoEditPage(RouteSettings settings) {
  if (settings.name == '/edit-photo') {
    final Photo args = settings.arguments as Photo;

    return MaterialPageRoute(builder: (context) {
      return MainScaffold(
        hasActionButton: false,
        child: PhotoEdit(
          imagePath: args.path,
        ),
      );
    });
  } else {
    throw 'No path provided';
  }
}
