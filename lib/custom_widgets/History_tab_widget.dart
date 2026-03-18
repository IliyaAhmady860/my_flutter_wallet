import 'package:flutter/material.dart';
import 'package:my_wallet/providers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:my_wallet/services/chart_services.dart';
import 'package:my_wallet/providers/total_summery_provider.dart';

// ToDO
// solve the overflow text problems and make the user be able to swipe and delete

// this is the dart file to store the widgets for the history tab

class MonthlyChart extends ConsumerWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(monthlySummaryProvider);

    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text("Error loading chart")),
      data: (data) {
        final income = data['income'] ?? 0.0;
        final expense = data['expense'] ?? 0.0;
        final total = income + expense;
        final balance = income - expense;
        if (total == 0)
          return const Center(child: Text("No data for this month"));
        final List<ChartData> dataSource = [
          ChartData('Income', income, Colors.greenAccent.shade700),
          ChartData('Expenses', expense, Colors.redAccent),
        ];
        return Column(
          children: [
            SizedBox(
              height: 180,
              child: charts.SfCircularChart(
                margin: EdgeInsets.zero,
                series: ChartService.buildSemiCircleSeries(
                  dataSource: dataSource,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSimpleIndicator("Income", Colors.greenAccent.shade700),
                const SizedBox(width: 20),
                _buildSimpleIndicator("Expense", Colors.redAccent),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    "\$${balance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: balance > 0
                          ? Colors.greenAccent.shade700
                          : Colors.redAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSimpleIndicator(String label, Color color) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class History extends ConsumerWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);
    return transactionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (transactions) {
        final hasMore = ref.watch(transactionProvider.notifier).hasMore;
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height * (2 / 5),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Monthly Transactions Summary",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const MonthlyChart(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < transactions.length) {
                      final item = transactions[index];
                      return Card(
                        color: Colors.grey.shade200,
                        child: ListTile(
                          title: Text(
                            item.title,
                            style: TextStyle(
                              color: item.transaction_type == 'expense'
                                  ? Colors.redAccent.shade400
                                  : Colors.greenAccent.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          trailing: item.transaction_type == 'expense'
                              ? Text(
                                  "-\$${item.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.redAccent.shade400,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                )
                              : Text(
                                  "+\$${item.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.greenAccent.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      );
                    }
                    if (hasMore && transactions.length >= 6) {
                      Future.microtask(
                        () =>
                            ref.read(transactionProvider.notifier).fetchMore(),
                      );
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  childCount: transactions.length + (notifier.hasMore ? 1 : 0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
