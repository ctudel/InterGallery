import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/db.dart' as db;
import '../models/local_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final LocalProvider settingValues = Provider.of<LocalProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 100.0),
      child: Column(
        children: [
          const ThemeSelector(),
          const Text('temp'),
          Row(
            children: [
              Text(settingValues.timePeriod),
              Switch(
                value: settingValues.twenty4Hour,
                onChanged: (bool value) {
                  setState(() {
                    // update format and text values
                    settingValues.setTimeFormat(value);
                    // update dates and time for photos in database
                    changeTimeFormat(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Upload photo to the database
  Future<void> changeTimeFormat(bool hour24) async {
    print('changing time format...');
    await db.changeTimeFormat(hour24);
  }
}

/// Widget to change theme of the app
class ThemeSelector extends StatefulWidget {
  const ThemeSelector({super.key});

  @override
  State<ThemeSelector> createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  String? _value = 'light';

  @override
  Widget build(BuildContext context) {
    // Theme managing
    final LocalProvider theme = Provider.of<LocalProvider>(context);

    return DropdownButton<String>(
      value: _value,
      isExpanded: true,
      onChanged: (String? selectedValue) {
        setState(() {
          _value = selectedValue ?? 'light';
          if (selectedValue == 'dark')
            theme.toggleTheme(true);
          else
            theme.toggleTheme(false);
        });
      },
      items: const <DropdownMenuItem<String>>[
        DropdownMenuItem<String>(value: 'light', child: Text('light')),
        DropdownMenuItem<String>(value: 'dark', child: Text('dark')),
      ],
    );
  }
}
