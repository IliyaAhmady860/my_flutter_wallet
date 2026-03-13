import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_widgets/tab_bar_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Spendify",
            style: TextStyle(color: Colors.greenAccent.shade700),
          ),
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.history, color: Colors.blueGrey),
              text: "History",
            ),
            Tab(
              icon: Icon(Icons.trending_up, color: Colors.green),
              text: "Analytics",
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [History(), Analytics()],
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(
            side: BorderSide(color: Colors.greenAccent.shade700),
          ),
          backgroundColor: Colors.greenAccent.shade700,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed("/transaction_input");
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
