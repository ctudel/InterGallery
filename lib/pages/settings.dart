import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/db.dart' as db;
import '../models/pageTheme.dart';

bool twenty4Hour = true;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _timePeriod = '24 hour time';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 100.0),
      child: Column(
        children: [
          const ThemeSelector(),
          const Text('temp'),
          Row(
            children: [
              Text(_timePeriod),
              Switch(
                value: twenty4Hour,
                onChanged: (bool value) {
                  setState(() {
                    twenty4Hour = value;
                    changeTimeFormat(value);
                    print(twenty4Hour);
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
    final PageTheme theme = Provider.of<PageTheme>(context);

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
