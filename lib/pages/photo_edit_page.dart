import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hw5/models/local_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../models/photo.dart';
import '../database/db.dart' as db;

class PhotoEdit extends StatefulWidget {
  final String imagePath;

  const PhotoEdit({super.key, required this.imagePath});

  @override
  State<PhotoEdit> createState() => _PhotoEditState();
}

class _PhotoEditState extends State<PhotoEdit> {
  // Future to get user's location
  late final Future _locationFuture = getLocationAndWeather();

  // GlobalKey for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final String _description; // Photo description

  @override
  Widget build(BuildContext context) {
    final LocalProvider settingValues = Provider.of<LocalProvider>(context);

    // Retrieves the correct formatter
    final DateFormat df = (settingValues.twenty4Hour)
        ? DateFormat('H:mm MMMM d, y')
        : DateFormat('h:mm a MMMM d, y');

    return Center(
        child: FutureBuilder(
            future: _locationFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final bool services = snapshot.data!.$1;
                final bool permissions = snapshot.data!.$2;
                final Map<String, dynamic>? locJson = snapshot.data!.$3;
                final Map<String, dynamic>? weatherJson = snapshot.data!.$4;
                final List<String> address =
                    locJson!["display_name"].split(',');
                final weather =
                    '${weatherJson!["main"]["temp"]}${weatherJson!["weather"][0]["main"]}';
                print(weatherJson);

                if (!services) {
                  return const Text('Enable location services to continue');
                }

                if (!permissions) {
                  return const Text(
                      'Please grant location permissions to continue');
                }

                // If user's permissions are all enabled and data is received
                //  display photo and prompt for metadata
                return Form(
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
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_pin),
                          const SizedBox(width: 20),
                          Text(address[1]),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud),
                          const SizedBox(width: 20),
                          Text('${weatherJson!["main"]["temp"]}F'),
                          const SizedBox(width: 5),
                          Text(weatherJson!["weather"][0]["main"]),
                        ],
                      ),
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
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  }),
                              FilledButton(
                                  child: const Text('Save'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      setState(() {
                                        _uploadPhoto(
                                          _description,
                                          df.format(DateTime.now()),
                                          address[1],
                                          weather
                                        );
                                        Navigator.of(context)
                                            .pushReplacementNamed('/');
                                      });
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                // Show an error if needed
              } else if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else // Snapshot had no data or future was not finished properly
                return const Text('Failed to retrieve locaiton');
            }));
  }

  // Upload photo to the database
  Future<void> _uploadPhoto(
      String description, String date, String location, String weather) async {
    print('saving photo...');

    await db.savePhoto(
      Photo(
        description: description,
        date: date,
        location: location,
        weather: weather,
        path: widget.imagePath,
      ),
    );
  }
}

/// Get the current location of the user
Future<
    (
      bool enabled,
      bool hasPermission,
      Map<String, dynamic>? locData,
      Map<String, dynamic>? weatherData
    )> getLocationAndWeather() async {
  // FIXME: Paste your api key here
  const String apiKey = ''; // OpenWeather API key

  Location location = Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return (false, false, null, null);
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted == PermissionStatus.denied) {
      return (true, false, null, null); // service enabled but no permissions
    }
  }

  final LocationData locationData =
      await location.getLocation(); // gives lat and lon

  final locationResponse = await http.get(Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${locationData.latitude}&lon=${locationData.longitude}'));

  final weatherResponse = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey&units=imperial'));

  final Map<String, dynamic> locJson = jsonDecode(locationResponse.body);
  final Map<String, dynamic> weatherJson = jsonDecode(weatherResponse.body);

  return (true, true, locJson, weatherJson);
}
