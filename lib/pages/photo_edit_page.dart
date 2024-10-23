import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../database/db.dart' as db;
import '../pages/homepage.dart';

class PhotoEdit extends StatefulWidget {
  const PhotoEdit({super.key});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  late Future<Photo> _photoFuture;
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    _photoFuture = _getPhoto(context);
  }

  Future<Photo> _getPhoto(context) async {
    // Extract arguements
    final args = ModalRoute.of(context)!.settings.arguments as Photo;

    print('saving photo...');

    // Taken photo
    await db.savePhoto(
        Photo(description: 'test photo', date: 'new date', path: args.path));

    photos = await db.getPhotos();
    print('getting photos');

    // Debugging info
    for (final photo in photos)
      print('Photo: ${photo.id}, ${photo.date}, ${photo.description}');

    // Return most recent photo
    return photos.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Photo')),
      body: FutureBuilder<Photo>(
        future: _photoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return Image.file(File(snapshot.data!.path));
          } else {
            return const Center(child: Text('No photo available'));
          }
        },
      ),
    );
  }
}
