import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../models/photo.dart';

late final Database _database;

Future<void> init() async {
  print('Checking initialization');

  final String path = join(await getDatabasesPath(), 'photos.db');

  _database = await openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE photos (id INTEGER PRIMARY KEY AUTOINCREMENT, description TEXT, date TEXT, path TEXT)');
      print('Table created');
    },
    version: 1,
  );

  changeTimeFormat(true);
}

/// Insert an image object
Future<void> savePhoto(Photo photo) async {
  _database.insert(
    'photos',
    photo.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/// Query all photos
Future<List<Photo>> getPhotos() async {
  final List<Photo> photos = [];
  final List<Map<String, dynamic>> maps = await _database.query('photos');

  for (final Map<String, dynamic> photo in maps)
    photos.add(Photo.fromMap(photo));

  return photos;
}

Future<void> deleteAllPhotos() async {
  final List<Map<String, dynamic>> maps = await _database.query('photos');
  final List<int> photos = List.generate(maps.length, (idx) {
    return maps[idx]["id"];
  });

  for (final int photo in photos) {
    await _database.delete(
      'photos',
      where: 'id = ?',
      whereArgs: <int>[photo],
    );
  }
}

Future<void> changeTimeFormat(bool hour24) async {
  final List<Map<String, dynamic>> maps = await _database.query('photos');

  for (final Map<String, dynamic> photo in maps) {
    final DateFormat f24 = DateFormat("H:mm MMMM d, y");
    final DateFormat f12 = DateFormat('h:mm a MMMM d, y');
    late final Photo newPhoto;

    // Parse old date
    final DateTime oldDate =
        (!hour24) ? f24.parse(photo["date"]) : f12.parse(photo["date"]);
    print(oldDate);

    // Switch format
    final String newDate =
        (!hour24) ? f12.format(oldDate) : f24.format(oldDate);
    print(newDate);

    // Create new photo instance with mutated date
    newPhoto = Photo(
      description: photo["description"],
      date: newDate,
      path: photo["path"],
    );

    await _database.update(
      'photos',
      newPhoto.toMap(),
      where: 'id = ?',
      whereArgs: <int>[photo["id"]],
    );
  }
}

// FIXME: Debugging databse only, delete once finished
Future<void> checkTableSchema() async {
  final List<Map<String, dynamic>> tableInfo =
      await _database.rawQuery('PRAGMA table_info(photos)');
  print('Table schema: $tableInfo');
}

// FIXME: Debugging database only, delete once finished
Future<void> deleteDatabase() async {
// Close the database
  await _database.close();

// Get the path to the database
  final String dbPath = join(await getDatabasesPath(), 'photos.db');

// Delete the database
  await databaseFactory.deleteDatabase(dbPath);

  print('Database deleted');
}
