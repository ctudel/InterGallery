import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/utils/utils.dart';

late final Database _database;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Checking initialization');

  // TODO: Make database that stores image paths

  _database = await openDatabase(
    join(await getDatabasesPath(), 'photos.db'),
    onCreate: (db, version) async {
      await db
          .execute('CREATE TABLE photos (id INTEGER PRIMARY KEY, path TEXT)');
      print('performing');
      print('finished');
    },
    version: 1,
  );
}

// TODO: Create method to insert into the database using parameters
Future<void> saveImage({String? path}) async {
  print('placeholder');
}

// TODO: Create getter to get image paths; some ideas include:
// Getting paths and storing them in a list
// Returning the image given an id (int)
// Add more here...

Future<List<String>> getImages() async {
  print('placeholder');
  return [];
}
