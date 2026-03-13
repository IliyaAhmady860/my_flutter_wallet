import 'package:flutter/material.dart';

import 'package:my_wallet/models/transaction_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _FinancialReportScreenState();
}

//# this section is fake data and fake chart and it  would be deleted and replaced after
//# the database is set up and the chart service is set up
class _FinancialReportScreenState extends State<Analytics> {
  final List<MonthlyFinancials> yearlyData = [
    MonthlyFinancials(month: 'Jan', income: 4500, spending: 3200),
    MonthlyFinancials(month: 'Feb', income: 4200, spending: 3800),
    MonthlyFinancials(month: 'Mar', income: 5000, spending: 3100),
    MonthlyFinancials(month: 'Apr', income: 4800, spending: 4900),
    MonthlyFinancials(month: 'May', income: 5200, spending: 3500),
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate Yearly Totals for the Pie Chart
    double totalIncome = yearlyData.fold(0, (sum, item) => sum + item.income);
    double totalSpending = yearlyData.fold(
      0,
      (sum, item) => sum + item.spending,
    );
    double yearlyNet = totalIncome - totalSpending;

    // Data for the Yearly Pie Chart
    final List<Map<String, dynamic>> yearlyPieData = [
      {
        'label': 'Net Savings',
        'value': yearlyNet > 0 ? yearlyNet : 0.0,
        'color': Colors.teal,
      },
      {
        'label': 'Total Expenses',
        'value': totalSpending,
        'color': Colors.redAccent,
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Monthly Correlation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * (1 / 3),
              child: charts.SfCartesianChart(
                primaryXAxis: const charts.CategoryAxis(),
                primaryYAxis: const charts.NumericAxis(
                  labelFormat: '\${value}',
                ),
                legend: const charts.Legend(
                  isVisible: true,
                  position: charts.LegendPosition.bottom,
                ),
                tooltipBehavior: charts.TooltipBehavior(enable: true),
                series: <charts.CartesianSeries<MonthlyFinancials, String>>[
                  charts.LineSeries<MonthlyFinancials, String>(
                    name: 'Income',
                    dataSource: yearlyData,
                    xValueMapper: (MonthlyFinancials data, _) => data.month,
                    yValueMapper: (MonthlyFinancials data, _) => data.income,
                    color: Colors.green,
                    width: 3, // Makes the line thicker
                    markerSettings: const charts.MarkerSettings(
                      isVisible: false,
                    ),
                  ),

                  // 2. Spending Line
                  charts.LineSeries<MonthlyFinancials, String>(
                    name: 'Spending',
                    dataSource: yearlyData,
                    xValueMapper: (MonthlyFinancials data, _) => data.month,
                    yValueMapper: (MonthlyFinancials data, _) => data.spending,
                    color: Colors.red,
                    width: 3,
                    dashArray: <double>[5, 5],
                    markerSettings: const charts.MarkerSettings(
                      isVisible: false,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              "Yearly Net Summary",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(
              height: 300,
              child: charts.SfCircularChart(
                legend: const charts.Legend(isVisible: true),
                series: <charts.CircularSeries<Map<String, dynamic>, String>>[
                  charts.PieSeries<Map<String, dynamic>, String>(
                    dataSource: yearlyPieData,
                    xValueMapper: (Map data, _) => data['label'],
                    yValueMapper: (Map data, _) => data['value'],
                    pointColorMapper: (Map data, _) => data['color'],
                    dataLabelSettings: const charts.DataLabelSettings(
                      isVisible: true,
                    ),
                    // Explode the Savings slice
                    explode: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: yearlyNet >= 0
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Yearly Net:", style: TextStyle(fontSize: 18)),
                      Text(
                        "${yearlyNet >= 0 ? '+' : ''}\$${yearlyNet.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: yearlyNet >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * (1 / 30)),
          ],
        ),
      ),
    );
  }
}

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: MediaQuery.of(context).size.height * (2 / 5),
            color: Colors.blueAccent,
            child: const Center(child: Text("More Wallet Details Here")),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height * (1 / 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(3, 3),
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
      ],
    );
  }
}
