import 'package:Spendify/models/transaction_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:Spendify/services/sqflite_db.dart';

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

final yearlySummeryProvider = FutureProvider<Map<String, double>>((ref) async {
  final db = await DatabaseHelper.instance.database;
  DateTime now = DateTime.now();
  String firstDay = DateTime(now.year, now.month, 1).toIso8601String();
  String lastDay = DateTime(now.year + 1, now.month, 0).toIso8601String();
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

final twelveMonthSummaryProvider = FutureProvider<List<MonthlyFinancials>>((
  ref,
) async {
  final db = await DatabaseHelper.instance.database;
  DateTime now = DateTime.now();
  List<MonthlyFinancials> history = [];
  for (int i = 11; i >= 0; i--) {
    DateTime targetMonth = DateTime(now.year, now.month - i, 1);
    String firstDay = DateTime(
      targetMonth.year,
      targetMonth.month,
      1,
    ).toIso8601String();
    String lastDay = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      1,
    ).toIso8601String();
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
    double spending = 0;

    for (var row in result) {
      if (row['transaction_type'] == 'income') {
        income = (row['total'] as num).toDouble();
      } else {
        spending = (row['total'] as num).toDouble();
      }
    }
    history.add(
      MonthlyFinancials(
        month: _getMonthName(targetMonth.month),
        income: income,
        spending: spending,
      ),
    );
  }
  return history;
});
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}
