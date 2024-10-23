import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../models/main_scaffold.dart';
import '../database/db.dart' as db;

class PhotoEdit extends StatefulWidget {
  const PhotoEdit({super.key});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  late final Photo args;
  late Future<Photo> _photoFuture;
  List<Photo> photos = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Photo;
    _photoFuture = _getPhoto();
  }

  Future<Photo> _getPhoto() async {
    print('saving photo...');

    print('PATH: ${args.path}');

    // Taken photo
    await db.savePhoto(
      Photo(description: 'new photo', date: 'new date', path: args.path),
    );

    photos = await db.getPhotos();
    print('getting photos');

    // Debugging info
    for (final photo in photos) {
      print('Photo: ${photo.id}, ${photo.date}, ${photo.description}');
    }

    // Return most recent photo
    return photos.last;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Photo>(
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
    );
  }
}
