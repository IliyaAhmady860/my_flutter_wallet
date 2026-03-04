import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/providers/nav_bar_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(navBarVisibilityProvider);
    final scrollController = ref.watch(scrollControllerProvider);
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        controller: scrollController,
        itemCount: 40,
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isVisible ? 90.0 : 0.0,
        child: Wrap(
          children: [
            BottomAppBar(
              color: Colors.blueGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Column(
                      children: [
                        FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: Colors.blue,
                          shape: const CircleBorder(),
                          child: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
