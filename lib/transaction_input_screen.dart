import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/transaction_model.dart';
import 'services/sqflite_db.dart';

//this file is used as the screen to input the transactions
//it has a form that takes the title, amount, type and date
//and validate them
//it also has a button to submit the form and add the transaction to the database

enum transactionType { expense, income }

class TransactionInput extends StatefulWidget {
  const TransactionInput({super.key});

  @override
  State<TransactionInput> createState() => _TransactionInputState();
}

class _TransactionInputState extends State<TransactionInput> {
  final _formKey = GlobalKey<FormState>();
  transactionType? _selectedTransactionType = transactionType.expense;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String year = picked.year.toString();
      String month = picked.month.toString().padLeft(2, '0');
      String day = picked.day.toString().padLeft(2, '0');
      setState(() {
        _dateController.text = "${year}-${month}-${day}";
      });
    }
  }

  void _onDonePressed() async {
    if (_formKey.currentState!.validate()) {
      final newTransaction = TransactionModel(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        transaction_type: _selectedTransactionType == transactionType.expense
            ? 'expense'
            : 'income',
        date: DateTime.parse(_dateController.text),
      );
      await DatabaseHelper.instance.insertTransaction(newTransaction);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, '0');
    String day = now.day.toString().padLeft(2, '0');
    _dateController.text = "$year-$month-$day";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add Transaction Details",
          style: TextStyle(color: Colors.greenAccent.shade700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
              child: TextFormField(
                controller: _titleController,
                autofocus: true,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.blueAccent.shade700,
                decoration: InputDecoration(
                  labelText: "Transaction Name",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }

                  if (RegExp(r'^[0-9]').hasMatch(value)) {
                    return 'Name cannot start with a number';
                  }

                  if (value.length > 20) {
                    return 'Name must be 20 characters or less';
                  }

                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
              child: TextFormField(
                controller: _amountController,
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.blueAccent.shade700,
                decoration: InputDecoration(
                  labelText: "Transaction Amount",
                  hintText: "0.000",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                ],

                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),

                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.parse(value) == 0) {
                    return 'Please enter an amount';
                  }
                  if (value == '.') {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) >= 9999999) {
                    return 'Bigger Than 10 Million TOO RICH';
                  }

                  return null;
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(9, 9, 9, 9),
              child: TextFormField(
                readOnly: true,
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: "Transaction Date",
                  hintText: "YYYY-MM-DD",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent.shade700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter or select a date';
                  }
                  return null;
                },
              ),
            ),

            RadioGroup(
              groupValue: _selectedTransactionType,
              onChanged: (transactionType? value) {
                setState(() {
                  _selectedTransactionType = value;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RadioListTile<transactionType>(
                      contentPadding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                      activeColor: Colors.red.shade700,
                      title: const Text('expense'),
                      value: transactionType.expense,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(9)),
                  Expanded(
                    child: RadioListTile<transactionType>(
                      activeColor: Colors.green.shade700,
                      contentPadding: EdgeInsets.fromLTRB(9, 0, 9, 0),
                      title: const Text('income'),
                      value: transactionType.income,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(
          side: BorderSide(color: Colors.greenAccent.shade700),
        ),
        backgroundColor: Colors.greenAccent.shade700,
        onPressed: _onDonePressed,
        child: Icon(Icons.done, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
