import 'package:flutter/material.dart';
import '../main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    String? value = 'light';

    return Column(
      children: [
        DropdownButton<String>(
          value: value,
          onChanged: (String? newValue) {
            setState(() {
              value = newValue;
            });
          },
          items: const [
            DropdownMenuItem<String>(child: Text('light')),
            DropdownMenuItem<String>(child: Text('dark')),
          ],
        ),
        const Text('theme'),
        const Text('temp'),
        const Text('time'),
      ],
    );
  }
}
