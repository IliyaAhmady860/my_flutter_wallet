import 'dart:math';
import 'package:Spendify/services/sqflite_db.dart';
import 'package:Spendify/models/transaction_model.dart';

//! 100% ai generated file to use as a function for a button to debug the database
class DatabaseDebugger {
  static Future<void> seedAndPrint() async {
    final dbHelper = DatabaseHelper.instance;

    print("🚀 Starting Database Seed...");

    // 1. Generate Fake Data
    List<String> fakeTitles = [
      "Grocery Store",
      "Gas Station",
      "Salary",
      "Coffee",
      "Netflix",
      "Rent",
      "Freelance",
    ];
    Random random = Random();

    for (int i = 0; i < 15; i++) {
      final isExpense = random.nextBool();
      final fakeTransaction = TransactionModel(
        title: fakeTitles[random.nextInt(fakeTitles.length)],
        amount:
            (random.nextDouble() * 100) + 5, // Random amount between 5 and 105
        transaction_type: isExpense ? 'expense' : 'income',
        // Generates dates for the last 15 days
        date: DateTime.now().subtract(Duration(days: i)),
      );

      await dbHelper.insertTransaction(fakeTransaction);
    }

    print("✅ 15 Fake Transactions Inserted.");

    // 2. Fetch and Print Everything
    print("\n--- 📊 CURRENT DATABASE CONTENT ---");

    final db = await dbHelper.database;
    final List<Map<String, dynamic>> allRows = await db.query('transactions');

    if (allRows.isEmpty) {
      print("The database is currently empty.");
    } else {
      for (var row in allRows) {
        print(
          "| ID: ${row['id'] ?? 'N/A'} | "
          "Type: ${row['transaction_type'].toString().padRight(8)} | "
          "Amt: ${row['amount'].toString().padRight(7)} | "
          "Date: ${row['date']} | "
          "Title: ${row['title']}",
        );
      }
    }
    print("-----------------------------------\n");
  }
}
