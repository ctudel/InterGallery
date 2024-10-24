import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo.dart';
import '../database/db.dart' as db;

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewType});

  final String viewType;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<Photo>> _photoFuture;
  late final Widget view;

  @override
  void initState() {
    super.initState();
    _photoFuture = _getPhoto();
  }

  // Get all photos from database
  Future<List<Photo>> _getPhoto() async {
    final List<Photo> photos = await db.getPhotos();
    return photos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Photo>>(
      future: _photoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          // Wait for data from database
        } else if (snapshot.hasData) {
          // List of all Photos
          final List<Photo>? photos = snapshot.data;

          // Gets the correct view selected
          view = switch (widget.viewType) {
            'home' => MainPage(photos: photos),
            'list' => ListPage(photos: photos),
            'grid' => GridPage(photos: photos),
            _ => MainPage(photos: photos)
          };

          // Main container
          return Container(
            padding: const EdgeInsets.only(top: 55, left: 20, right: 20),
            // Separated item list
            child: view,
          );
        } else {
          return const Center(child: Text('No photo available'));
        }
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.photos,
  });

  final List<Photo>? photos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(0),
        itemCount: photos!.length,
        separatorBuilder: (context, idx) {
          return const SizedBox(width: 20);
        },
        // Photo item builder
        itemBuilder: (BuildContext context, int index) {
          // Photo content
          return Column(
            children: [
              Text(photos![index].description),
              Text(photos![index].date),
              Image.file(File(photos![index].path)),
            ],
          );
        });
  }
}

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
    required this.photos,
  });

  final List<Photo>? photos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: photos!.length,
        separatorBuilder: (context, idx) {
          return const SizedBox(width: 10);
        },
        // Photo item builder
        itemBuilder: (BuildContext context, int index) {
          // Photo content
          return Row(
            children: [
              Image.file(scale: 5, File(photos![index].path)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(photos![index].description),
                    Text(photos![index].date),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class GridPage extends StatelessWidget {
  const GridPage({
    super.key,
    required this.photos,
  });

  final List<Photo>? photos;

  @override
  Widget build(BuildContext context) {
    const TextStyle head = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: Colors.black54,
    );
    const TextStyle sub = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Colors.black45,
    );

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: photos!.length,
        itemBuilder: (context, index) {
          return Card(
              color: const Color.fromRGBO(211, 188, 253, 1),
              elevation: 8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(photos![index].path),
                    ),
                  ),
                  Text(
                    photos![index].description,
                    style: head,
                  ),
                  Text(
                    photos![index].date,
                    style: sub,
                  ),
                ],
              ));
        });
  }
}
