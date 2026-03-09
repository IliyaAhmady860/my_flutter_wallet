class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String transaction_type;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.transaction_type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'transaction_type': transaction_type,
      'date': date.toIso8601String(), // Store the date as a String
    };
  }
}

class MonthlyFinancials {
  final String month;
  final double income;
  final double spending;
  final double net;

  MonthlyFinancials({
    required this.month,
    required this.income,
    required this.spending,
  }) : net = income - spending;
}
