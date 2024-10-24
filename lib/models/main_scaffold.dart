import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
    this.hasActionButton = true,
  });

  final Widget child;
  final bool hasActionButton;

  @override
  Widget build(BuildContext context) {
    // Page with action button
    if (hasActionButton) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('WindowPane'),
          // actions: [
          //   ElevatedButton(
          //     onPressed: () {
          //       Navigator.of(context).pushNamed('/settings');
          //     },
          //     child: Icon(Icons.settings),
          //   )
          // ],
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
            Navigator.of(context).pushReplacementNamed(switch (idx) {
              0 => '/list',
              1 => '/grid',
              2 => '/',
              _ => 'Failed to retrieve page.'
            })
          },
        ),
      );
      // Page with no action button
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('WindowPane'),
        ),
        body: child,
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
            Navigator.of(context).pushReplacementNamed(switch (idx) {
              0 => '/list',
              1 => '/grid',
              2 => '/',
              _ => 'Failed to retrieve page.'
            })
          },
        ),
      );
    }
  }
}
