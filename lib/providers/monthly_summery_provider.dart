import 'package:riverpod/riverpod.dart';
import 'package:my_wallet/services/sqflite_db.dart';

//provides the summary of the month to the history tab for the chart and the chart service

final monthlySummaryProvider = FutureProvider<Map<String, double>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  DateTime now = DateTime.now();
  String firstDay = DateTime(now.year, now.month, 1).toIso8601String();
  String lastDay = DateTime(now.year, now.month + 1, 0).toIso8601String();
  final List<Map<String, dynamic>> result = await db.rawQuery(
    '''
    SELECT transaction_type, SUM(amount) as total 
    FROM transactions 
    WHERE date BETWEEN ? AND ?
    GROUP BY transaction_type
  ''',
    [firstDay, lastDay],
  );
  double income = 0;
  double expense = 0;
  for (var row in result) {
    if (row['transaction_type'] == 'income') {
      income = (row['total'] as num).toDouble();
    } else {
      expense = (row['total'] as num).toDouble();
    }
  }
  return {'income': income, 'expense': expense};
});
