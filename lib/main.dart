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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: (RouteSettings settings) =>
          route_model.photoEditPage(settings),
      routes: route_model.routes,
    );
  }
}
