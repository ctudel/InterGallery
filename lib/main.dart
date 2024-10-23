import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pages/camera.dart';
import 'pages/homepage.dart';
import 'pages/photo_edit_page.dart';
import 'models/main_scaffold.dart';
import 'database/db.dart' as db;

late final List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await db.init();
  await db.checkTableSchema();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MainScaffold(
            title: 'Flutter Demo Home Page', child: HomePage()),
        routes: {
          '/camera': (context) => Camera(camera: _cameras[0]),
          '/edit-photo': (context) => const PhotoEdit(),
        });
  }
}
