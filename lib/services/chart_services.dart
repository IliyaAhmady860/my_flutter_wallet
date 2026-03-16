import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

//! ToDo
// create a class for the chart services
// create at min 2 different charts in my app using the chart services

class ChartData {
  final String category;
  final double value;
  final Color color;
  ChartData(this.category, this.value, this.color);
}

class ChartService {
  static List<charts.DoughnutSeries<ChartData, String>> buildSemiCircleSeries({
    required List<ChartData> dataSource,
  }) {
    double totalValue = dataSource.fold(0, (sum, item) => sum + item.value);

    return [
      charts.DoughnutSeries<ChartData, String>(
        dataSource: dataSource,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.value,
        pointColorMapper: (ChartData data, _) => data.color,
        startAngle: 270,
        endAngle: 90,
        innerRadius: '70%',
        dataLabelSettings: const charts.DataLabelSettings(
          isVisible: true,
          labelPosition: charts.ChartDataLabelPosition.outside,
          textStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        dataLabelMapper: (ChartData data, _) {
          if (totalValue == 0) return '0%';
          double percentage = (data.value / totalValue) * 100;
          return '${percentage.toStringAsFixed(0)}%';
        },
      ),
    ];
  }
}
