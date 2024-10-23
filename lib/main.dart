import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'pages/camera.dart';
import 'database/db.dart' as db;

late final List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  await db.init();

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
            title: 'Flutter Demo Home Page',
            child: Text('Start of a new project')),
        routes: {
          '/camera': (context) => Camera(camera: _cameras[0]),
        });
  }
}

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          FilledButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              child: const Icon(Icons.home))
        ],
      ),
      body: child,
      // Take picture button
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/camera'),
        tooltip: 'New Photo',
        child: const Icon(Icons.camera_alt),
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'Grid'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'Home'),
        ],
        onTap: (idx) => {
          switch (idx) { 0 => '0', 1 => '1', _ => 'Failed to retrieve page.' }
        },
      ),
    );
    // Page with no camera button
  }
}
