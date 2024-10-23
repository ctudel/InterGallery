import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
    required this.title,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          FilledButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
              child: const Icon(Icons.home))
        ],
      ),
      body: child,
      // Take picture button
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/camera'),
        tooltip: 'New Photo',
        child: const Icon(Icons.camera_alt),
      ),
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'Grid'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'Home'),
        ],
        onTap: (idx) => {
          switch (idx) { 0 => '0', 1 => '1', _ => 'Failed to retrieve page.' }
        },
      ),
    );
    // Page with no camera button
  }
}
