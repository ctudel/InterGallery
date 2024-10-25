import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hw5/models/local_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:http/http.dart';
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
  late final String _description;

  @override
  Widget build(BuildContext context) {
    final LocalProvider settingValues = Provider.of<LocalProvider>(context);

    // Retrieves the correct formatter
    final DateFormat df = (settingValues.twenty4Hour)
        ? DateFormat('H:mm MMMM d, y')
        : DateFormat('h:mm a MMMM d, y');

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
            Text(df.format(DateTime.now())),
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
                                  _description, df.format(DateTime.now()));
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

Future<(bool enabled, bool hasPermission, Map<String, dynamic>? data)>
    getLocation() async {
  // TODO: Create a new instance of a Location object
  Location location = new Location();

  // TODO: Use the Location::serviceEnabled() method to check if location services are enabled.
  // If not, use the Location::requestService() method to request them
  // If they are still not enabled after requesting them, return a record with all fields false or null
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) return (false, false, null);
  }

  // TODO: Use the Location::hasPermission() method to check if permission is denied (PermissionStatus.denied).
  // If not, use the Location::requestPermission() method to request permission
  // If is still denied after requesting them, return a record with enabled = true, and all other fields false or null
  PermissionStatus _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.denied)
      return (true, false, null); // service enabled but no permissions
  }

  // TODO: Use the Location::getLocation() method to get the current location.
  final _location = await location.getLocation(); // gives lat and lon

  // TODO: Use the Nominatim API to get data about the current location. The URL should take the form:
  // https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude"
  // Where latitude and longitude are the values returned from Location::getLocation
  // The response.body of the API will contain a json string that needs to be decoded and cast as a Map
  final response = await http.get(Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${_location.latitude}&lon=${_location.longitude}'));

  final json = jsonDecode(response.body) as Map<String, dynamic>;

  // TODO: Return a record with enabled=true, hasPermission=true, and data set to the decoded json string from the API
  return (true, true, json);
}
