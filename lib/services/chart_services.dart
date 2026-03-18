import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as charts;

//! ToDo
////create a class for the chart services
//// create at min 2 different charts in my app using the chart service

// chart services needed for the charts in both the analytics and history tabs
class ChartData {
  final String category;
  final double value;
  final Color? color;
  ChartData(this.category, this.value, [this.color]);
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
          alignment: charts.ChartAlignment.center,
          labelPosition: charts.ChartDataLabelPosition.outside,
        ),
        dataLabelMapper: (ChartData data, _) =>
            '${((data.value / totalValue) * 100).toStringAsFixed(0)}%',
      ),
    ];
  }

  static List<charts.PieSeries<ChartData, String>> buildPieSeries({
    required List<ChartData> dataSource,
  }) {
    return [
      charts.PieSeries<ChartData, String>(
        dataSource: dataSource,
        xValueMapper: (ChartData data, _) => data.category,
        yValueMapper: (ChartData data, _) => data.value,
        pointColorMapper: (ChartData data, _) => data.color,
        explode: false,
        dataLabelSettings: const charts.DataLabelSettings(
          isVisible: true,
          labelPosition: charts.ChartDataLabelPosition.outside,
        ),
      ),
    ];
  }

  static charts.LineSeries<T, String> buildLineSeries<T>({
    required String name,
    required List<T> dataSource,
    required String Function(T, int) xMapper,
    required num? Function(T, int) yMapper,
    required Color color,
    bool isDashed = false,
  }) {
    return charts.LineSeries<T, String>(
      name: name,
      dataSource: dataSource,
      xValueMapper: xMapper,
      yValueMapper: yMapper,
      color: color,
      width: 3,
      dashArray: isDashed ? <double>[5, 5] : null,
      markerSettings: const charts.MarkerSettings(
        isVisible: true,
        height: 8,
        width: 8,
        shape: charts.DataMarkerType.circle,
      ),
    );
  }
}
