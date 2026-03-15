//this is a model class for transactions
//it is used to make a new transaction using
//the transaction input screen which takes
//the title, amount, transaction type, and date
//this model is used inside the transaction input screen
//also the db service file

class TransactionModel {
  final String title;
  final double amount;
  final String transaction_type;
  final DateTime date;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.transaction_type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'transaction_type': transaction_type,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      transaction_type: map['transaction_type'] ?? 'expense',
      date: DateTime.parse(map['date']),
    );
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
