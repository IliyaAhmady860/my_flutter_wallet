import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/nav_bar_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ref.watch(scrollControllerProvider);

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      // Removed the top AppBar
      body: ListView.builder(
        controller: scrollController,
        itemCount: 40,
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FabCircularMenuPlus(
        alignment: Alignment.bottomRight,
        ringDiameter: 300.0,
        ringWidth: 70.0,
        fabSize: 70.0,
        fabOpenIcon: const Icon(Icons.add, color: Colors.white, size: 40.0),
        fabCloseIcon: const Icon(Icons.close, color: Colors.white, size: 40.0),
        ringColor: Colors.transparent,
        fabOpenColor: Colors.blueGrey,
        fabCloseColor: Colors.blueGrey,
        children: <Widget>[
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.blueGrey),
            icon: const Icon(Icons.trending_down, size: 40),
            onPressed: () {},
            color: Colors.redAccent,
          ),
          IconButton(
            style: IconButton.styleFrom(backgroundColor: Colors.blueGrey),
            icon: const Icon(Icons.trending_up, size: 40),
            onPressed: () {},
            color: Colors.greenAccent,
          ),
        ],
      ),
    );
  }
}
