import 'package:flutter/material.dart';
import 'package:hw5/pages/photo_edit_page.dart';
import 'models/routes.dart' as route_model;
import 'models/photo.dart';
import 'database/db.dart' as db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.init();
  await db.checkTableSchema();

  await route_model.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      onGenerateRoute: (RouteSettings settings) =>
          route_model.photoEditPage(settings),
      routes: route_model.routes,
    );
  }
}
