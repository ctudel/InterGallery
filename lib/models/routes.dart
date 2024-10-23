import 'package:camera/camera.dart';
import 'package:hw5/models/main_scaffold.dart';
import 'package:hw5/pages/homepage.dart';
import '../pages/photo_edit_page.dart';
import '../pages/camera.dart';

late final List<CameraDescription> _cameras;

Future<void> init() async {
  _cameras = await availableCameras();
}

final routes = {
  '/': (context) => homePage,
  '/camera': (context) => Camera(camera: _cameras[0]),
  '/edit-photo': (context) => editPhotoPage,
};

// ===========================
// Pages with default scaffold
// ===========================
final MainScaffold homePage = MainScaffold(child: HomePage(), title: 'Home');

final MainScaffold editPhotoPage =
    MainScaffold(child: PhotoEdit(), title: 'Photo Editor');
