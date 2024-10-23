import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../database/db.dart' as db;
import '../pages/homepage.dart';

class PhotoEdit extends StatefulWidget {
  final String imagePath;

  const PhotoEdit({super.key, required this.imagePath});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  late Future<Photo> _photoFuture;
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    _photoFuture = _getPhoto();
  }

  Future<Photo> _getPhoto() async {
    print('saving photo...');

    // Taken photo
    await db.savePhoto(
      Photo(description: 'new photo', date: 'new date', path: widget.imagePath),
    );

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
