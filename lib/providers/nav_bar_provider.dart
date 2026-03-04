import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. The Modern Notifier (Replaces StateProvider)
class NavBarNotifier extends Notifier<bool> {
  @override
  bool build() => true; // Initial state: visible

  void show() => state = true;
  void hide() => state = false;
}

final navBarVisibilityProvider = NotifierProvider<NavBarNotifier, bool>(
  NavBarNotifier.new,
);
final scrollControllerProvider = Provider.autoDispose<ScrollController>((ref) {
  final controller = ScrollController();

  controller.addListener(() {
    if (!controller.hasClients) return;

    final direction = controller.position.userScrollDirection;

    if (direction == ScrollDirection.reverse) {
      ref.read(navBarVisibilityProvider.notifier).hide();
    } else if (direction == ScrollDirection.forward) {
      ref.read(navBarVisibilityProvider.notifier).show();
    }
  });

  ref.onDispose(() => controller.dispose());
  return controller;
});
