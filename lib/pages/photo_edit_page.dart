import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/photo.dart';
import '../database/db.dart' as db;

class PhotoEdit extends StatefulWidget {
  final String imagePath;

  const PhotoEdit({super.key, required this.imagePath});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DateFormat _df = DateFormat('H:m MMMM d, y'); // date formatter
  late final String _description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Text field
            Padding(
              padding: const EdgeInsets.only(right: 40, left: 40),
              child: TextFormField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: 'Please enter a description'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }

                  return null;
                },
                onSaved: (String? value) {
                  _description = value ?? '';
                },
              ),
            ),
            // Date
            Text(_df.format(DateTime.now())),
            // Image display
            Image.file(File(widget.imagePath)),
            // Discard and Save buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FilledButton(
                        child: const Text('Discard'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        }),
                    FilledButton(
                        child: const Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _uploadPhoto(
                                  _description, _df.format(DateTime.now()));
                              Navigator.of(context).pushReplacementNamed('/');
                            });
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Upload photo to the database
  Future<void> _uploadPhoto(String description, String date) async {
    print('saving photo...');

    // Taken photo
    await db.savePhoto(
      // Photo(description: 'new photo', date: 'new date', path: args.path),
      Photo(description: description, date: date, path: widget.imagePath),
    );
  }
}
