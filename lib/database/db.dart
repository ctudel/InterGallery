import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/utils/utils.dart';
import '../models/photo.dart';

late final Database _database;

Future<void> init() async {
  print('Checking initialization');
  final String path = join(await getDatabasesPath(), 'photos.db');

  // TODO: Make database that stores image paths

  _database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE photos (id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, date TEXT, path TEXT)');
      print('performing');
      print('finished');
    },
  );
}

/// Insert an image object
Future<void> saveImage(Photo image) async {
  _database.insert(
    'photos',
    image.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/// Get all photos
Future<List<Photo>> getImages() async {
  final List<Map<String, dynamic>> maps = await _database.query('photos');

  return List.generate(maps.length, (i) {
    return Photo(
        id: maps[i]['id'],
        description: maps[i]['description'],
        date: maps[i]['date'],
        path: maps[i]['path']);
  });
}
