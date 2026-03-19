import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_widgets/History_tab_widget.dart';
import 'custom_widgets/Analytics_tab_widget.dart';
import 'providers/transaction_provider.dart';
import 'providers/total_summery_provider.dart';

//the main screen which include the basic layout of tabs
//its using riverpod as the state management

enum MenuAction { refresh, delete }

Future<void> _showDeleteConfirmDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(
        "Delete Everything?",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        "This will permanently wipe your entire history. This cannot be undone.",
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            await ref
                .read(transactionProvider.notifier)
                .deleteAllTransactions();
            ref.invalidate(monthlySummaryProvider);
            ref.invalidate(twelveMonthSummaryProvider);
            ref.invalidate(yearlySummeryProvider);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text("DELETE ALL", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<MenuAction>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              offset: const Offset(0, 50),
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.refresh:
                    ref.invalidate(transactionProvider);
                    ref.invalidate(monthlySummaryProvider);
                    ref.invalidate(twelveMonthSummaryProvider);
                    break;
                  case MenuAction.delete:
                    await _showDeleteConfirmDialog(context, ref);
                    break;
                }
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: MenuAction.refresh,
                  child: ListTile(
                    leading: Icon(Icons.refresh, size: 20),
                    title: Text("Refresh Data"),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: MenuAction.delete,
                  child: ListTile(
                    leading: Icon(Icons.delete, size: 20, color: Colors.red),
                    title: Text("Clear Data"),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
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
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            await Navigator.of(context).pushNamed("/transaction_input");
            ref.read(transactionProvider.notifier).refresh();
            ref.invalidate(monthlySummaryProvider);
            ref.invalidate(twelveMonthSummaryProvider);
            ref.invalidate(yearlySummeryProvider);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
