import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pageTheme.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? _value = 'light';

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<PageTheme>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 40.0, right: 100.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: _value,
            isExpanded: true,
            onChanged: (String? selectedValue) {
              setState(() {
                _value = selectedValue ?? 'light';
                if (selectedValue == 'dark') theme.toggleTheme(true);
                else theme.toggleTheme(false);
              });
            },
            items: const <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                  value: 'light', child: Text('light')),
              DropdownMenuItem<String>(value: 'dark', child: Text('dark')),
            ],
          ),
          const Text('theme'),
          const Text('temp'),
          const Text('time'),
        ],
      ),
    );
  }
}
