import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "your account history",
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FabCircularMenuPlus(
          alignment: Alignment.bottomRight,
          ringDiameter: 300.0,
          ringWidth: 70.0,
          fabSize: 70.0,
          fabOpenIcon: const Icon(Icons.add, color: Colors.white, size: 40.0),
          fabCloseIcon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 40.0,
          ),
          ringColor: Colors.transparent,
          fabOpenColor: Colors.greenAccent[700],
          fabCloseColor: Colors.greenAccent[700],
          children: <Widget>[
            IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.black),
              icon: const Icon(Icons.trending_down, size: 40),
              onPressed: () {},
              color: Colors.redAccent,
            ),
            IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.blue),
              icon: const Icon(Icons.trending_up, size: 40),
              onPressed: () {},
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}

// Todo
//* move this 2 widgets to a separate file called custom widgets.dart
class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                itemCount: 10,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Wallet Item $index')),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * (2 / 3),
            color: Colors.blueAccent,
            child: const Center(child: Text("More Wallet Details Here")),
          ),
        ),
      ],
    );
  }
}

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(16.0),
                itemCount: 10,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('Wallet Item $index')),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * (2 / 3),
            color: Colors.blueAccent,
            child: const Center(child: Text("More Wallet Details Here")),
          ),
        ),
      ],
    );
  }
}
