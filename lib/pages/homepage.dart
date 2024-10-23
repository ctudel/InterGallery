import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../database/db.dart' as db;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Photo>> _photoFuture;

  @override
  void initState() {
    super.initState();
    _photoFuture = _getPhoto();
  }

  Future<List<Photo>> _getPhoto() async {
    final photos = await db.getPhotos();
    print('getting photos');

    // Debugging info
    for (final photo in photos) {
      print('Photo: ${photo.id}, ${photo.date}, ${photo.description}');
    }

    // Return most recent photo
    return photos;
  }

  void refreshPhotos() {
    _photoFuture = _getPhoto();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: _photoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final photos = snapshot.data;
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(0),
                  itemCount: photos!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(photos[index].path));
                  }),
            ),
          );
        } else {
          return const Center(child: Text('No photo available'));
        }
      },
    );
  }
}
