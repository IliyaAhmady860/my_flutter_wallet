import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;
import 'package:Spendify/services/chart_services.dart';
import 'package:Spendify/providers/total_summery_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// this is the dart file to store the widgets for the analytics tab
// it is using riverpod as the state management and also uses chart_services for the charts

class Analytics extends ConsumerWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearlySummaryAsync = ref.watch(yearlySummeryProvider);
    final twelveMonthAsync = ref.watch(twelveMonthSummaryProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Monthly Correlation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            twelveMonthAsync.when(
              loading: () => const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Text("Error loading correlation: $err"),
              data: (historyData) => SizedBox(
                height: MediaQuery.of(context).size.height * (2 / 5),
                child: charts.SfCartesianChart(
                  primaryXAxis: const charts.CategoryAxis(),
                  legend: const charts.Legend(
                    isVisible: true,
                    position: charts.LegendPosition.bottom,
                  ),
                  tooltipBehavior: charts.TooltipBehavior(enable: true),
                  series: <charts.CartesianSeries>[
                    ChartService.buildLineSeries(
                      name: 'Income',
                      dataSource: historyData,
                      xMapper: (data, _) => data.month,
                      yMapper: (data, _) => data.income,
                      color: Colors.green,
                      isDashed: true,
                    ),
                    ChartService.buildLineSeries(
                      name: 'Spending',
                      dataSource: historyData,
                      xMapper: (data, _) => data.month,
                      yMapper: (data, _) => data.spending,
                      color: Colors.red,
                      isDashed: true,
                    ),
                    ChartService.buildLineSeries(
                      name: 'savings',
                      dataSource: historyData,
                      xMapper: (data, _) => data.month,
                      yMapper: (data, _) => data.income - data.spending,
                      color: Colors.black,
                      isDashed: false,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text("tap the above buttons to filter"),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Yearly Net Summary",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            yearlySummaryAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text("Error loading summary: $err"),
              data: (summary) {
                final income = summary['income'] ?? 0.0;
                final expense = summary['expense'] ?? 0.0;
                final net = income - expense;
                final List<ChartData> pieData = [
                  ChartData('income', income, Colors.teal),
                  ChartData('expense', expense, Colors.redAccent),
                ];
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (2 / 5),
                      child: charts.SfCircularChart(
                        legend: const charts.Legend(isVisible: true),
                        series: ChartService.buildPieSeries(
                          dataSource: pieData,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _buildSummaryCard(net),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(double net) {
    return Card(
      elevation: 0,
      color: net >= 0 ? Colors.green.shade50 : Colors.red.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Yearly Net:", style: TextStyle(fontSize: 16)),
            Text(
              "${net >= 0 ? '+' : ''}\$${net.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: net >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
