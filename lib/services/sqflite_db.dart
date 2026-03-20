import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:Spendify/models/transaction_model.dart';
// the data base file
// it helps to store the transactions by initializing the database
// it will also provide the basic methods to read and write to the database

// ToDo
//// make and init the database
//// make a read and
///write method for the database
// make a delete method

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('Cash_flow.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,        
      transaction_type TEXT NOT NULL,          
      date TEXT NOT NULL          
    )
  ''');
  }

  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteAllTransactions() async {
    final db = await instance.database;
    await db.delete('transactions');
  }

  Future<List<TransactionModel>> getPagedTransactions(
    int limit,
    int offset,
  ) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      limit: limit,
      offset: offset,
      orderBy: 'date DESC',
    );
    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }
}
