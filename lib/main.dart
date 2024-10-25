import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/pageTheme.dart';
import 'models/routes.dart' as route_model;
import 'database/db.dart' as db;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await db.init();
  await db.checkTableSchema();

  await route_model.init();

  runApp(
      ChangeNotifierProvider(
        create: (context) => PageTheme(),
          child: const MyApp(),) as Widget,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
  final theme = Provider.of<PageTheme>(context);

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
     themeMode: theme.themeData,
     onGenerateRoute: (RouteSettings settings) =>
         route_model.photoEditPage(settings),
     routes: route_model.routes,
   );
  }
}

